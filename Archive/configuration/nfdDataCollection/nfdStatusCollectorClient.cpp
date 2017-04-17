/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil; -*- */
/**
 * Copyright (c) 2014, Washington University in St. Louis,
 *
 */

#include <boost/asio.hpp>
#include <ndn-cxx/face.hpp>
#include <ndn-cxx/management/nfd-face-status.hpp>
#include <ndn-cxx/encoding/buffer-stream.hpp>
#include <unordered_set>
#include <ndn-cxx/security/key-chain.hpp>
#include "nfdStatusCollector.hpp"

#define APP_SUFFIX "/ndnmap/stats"
#define SCRIPT_SUFFIX "/script"

// global variable to support debug
int DEBUG = 0;

namespace ndn {
  class NdnMapClient
  {
  public:
    
    NdnMapClient(char* programName)
    : m_programName(programName)
    {
    }
    
    void
    usage()
    {
      std::cout << "\n Usage:\n " << m_programName <<
      ""
      "[-h] -p interest_filter [-d debug_mode]\n"
      " pull local nfd performace and send it as a response to an interest from a remote server.\n"
      "\n"
      " \t-h - print this message and exit\n"
      " \t-p - prefix (of this host) to register as the interest's filter\n"
      " \t-d - sets the debug mode, 1 - debug on, 0 - debug off (default)\n"
      " \t-b - set size of buffer for storing data collected, useful for \n \t\t  scripts collecting large data sets. Default is 1024 bytes \n"
      "\n";
      exit(1);
    }
    
    void
    onTimeout(const Interest& interest)
    {
      std::cout << "onTimeout" << std::endl;
    }

    void
    afterFetchedFaceStatusInformation(const shared_ptr<OBufferStream>& buffer, const Name& remoteName)
    {
      ConstBufferPtr buf = buffer->buf();
      
      Block block;
      size_t offset = 0;
      
      std::string currentTime;
      std::tm ctime;
      std::stringstream realEpochTime;
      ndn::time::system_clock::TimePoint realCurrentTime = ndn::time::system_clock::now();
      std::string currentTimeStr = ndn::time::toString(realCurrentTime, "%Y-%m-%dT%H:%M:%S%F");
      
      strptime(currentTimeStr.c_str(), "%FT%T%Z", &ctime);
      std::string stime(currentTimeStr);
      std::time_t realEpochSeconds = std::mktime(&ctime);
      std::size_t pos = stime.find(".");
      std::string realEpochMilli = stime.substr(pos+1);
      realEpochTime << realEpochSeconds << "." << realEpochMilli;

      CollectorData content;

      currentTime =  realEpochTime.str();

      while (offset < buf->size())
      {
        bool ok = Block::fromBuffer(buf, offset, block);
        if (!ok)
        {
          std::cerr << "ERROR: cannot decode FaceStatus TLV" << std::endl;
          break;
        }
        
        offset += block.size();
        
        nfd::FaceStatus faceStatus(block);
        
        // take only udp4 and tcp4 faces at the moment
        std::string remoteUri = faceStatus.getRemoteUri();
        if(remoteUri.compare(0,4,"tcp4") != 0 &&
           remoteUri.compare(0,4,"udp4") != 0)
          continue;

        // take the ip from uri (remove tcp4:// and everything after ':'
        std::size_t strPos = remoteUri.find_last_of(":");
        std::string remoteIp = remoteUri.substr(7,strPos - 7);
        
        std::unordered_set<std::string>::const_iterator got = m_remoteLinks.find(remoteIp);       
        // the link is not requested by the server
       if(got == m_remoteLinks.end())
          continue;   

        FaceStatus linkStatus;
        linkStatus.setTx(faceStatus.getNOutBytes());
        linkStatus.setRx(faceStatus.getNInBytes());
        linkStatus.setFaceId(faceStatus.getFaceId());
        linkStatus.setLinkIp(remoteIp);
        linkStatus.setTimestamp(currentTime);
        
        // remove the remoteIP from the list of links to search and add it to the data packet
        m_remoteLinks.erase(remoteIp);
        content.add(linkStatus);
        
        if (DEBUG)
          std::cout << "about to send back " << linkStatus.getFaceId() << ": " << linkStatus.getRx() << ", " << linkStatus.getTx() << ", " << linkStatus.getLinkIp() << std::endl;
      }
      
      if (content.size() != 0)
      {
        ndn::shared_ptr<ndn::Data> data = ndn::make_shared<ndn::Data>(remoteName);
        data->setContent(content.wireEncode());
        data->setFreshnessPeriod(time::seconds(0));
        
        m_keyChain.sign(*data);
        m_face.put(*data);
      }
    }

    void
    fetchSegments(const Data& data, const shared_ptr<OBufferStream>& buffer, Name& remoteName,
                  void (NdnMapClient::*onDone)(const shared_ptr<OBufferStream>&, const Name& ))
    {
      buffer->write(reinterpret_cast<const char*>(data.getContent().value()),
                    data.getContent().value_size());
      
      uint64_t currentSegment = data.getName().get(-1).toSegment();
      
      const name::Component& finalBlockId = data.getMetaInfo().getFinalBlockId();
      if (finalBlockId.empty() ||
          finalBlockId.toSegment() > currentSegment)
      {
        m_face.expressInterest(data.getName().getPrefix(-1).appendSegment(currentSegment+1),
                               bind(&NdnMapClient::fetchSegments, this, _2, buffer, remoteName, onDone),
                               bind(&NdnMapClient::onTimeout, this, _1));
      }
      else
      {
        return (this->*onDone)(buffer,remoteName);
      }
    }

    void
    fetchFaceStatusInformation(Name& remoteInterestName)
    {
      shared_ptr<OBufferStream> buffer = make_shared<OBufferStream>();
      
      Interest interest("/localhost/nfd/faces/list");
      interest.setChildSelector(0);
      interest.setMustBeFresh(true); 
      
      m_face.expressInterest(interest,
                             bind(&NdnMapClient::fetchSegments, this, _2, buffer, remoteInterestName,
                                  &NdnMapClient::afterFetchedFaceStatusInformation),
                             bind(&NdnMapClient::onTimeout, this, _1));
      
      m_face.processEvents(time::milliseconds(100));
    }

    void
    onInterest(const ndn::Name& name, const ndn::Interest& interest)
    {
      ndn::Name interestName(interest.getName());

      if(DEBUG)
        std::cout << "received interest: " << interest.getName() << std::endl;
      
      //run scripts if requested by server
      ndn::Name cmpName(getFilter()+SCRIPT_SUFFIX);
      int num_components = cmpName.size();
      if(cmpName.isPrefixOf(interestName))
      {
        int numberOfComponents = interestName.size();
	      for(int i = num_components; i < numberOfComponents; ++i)
        {
          m_scriptsList.push_front(interestName[i].toUri());
        }
        runScripts(interestName);
      } 
      else 
      {
        int numberOfComponents = interestName.size();
        if(!m_remoteLinks.empty())
        {
          std::cerr << "remote links list is not empty - check for a missing reports!!" << std::endl;
          m_remoteLinks.clear();
        }
        for(int i = name.size(); i < numberOfComponents; ++i)
        { 
          m_remoteLinks.insert(interestName[i].toUri());
        }

        // ask for local status
        fetchFaceStatusInformation(interestName);
      }
    }

    void
    runScripts(ndn::Name& interestName)
    {
      std::string result, tmpString;
      std::string prefix = "./";
      FILE* pipe;
      const char* cmd; 
      char buf[BUF_SIZE];

      while (!m_scriptsList.empty())
      {
        tmpString = prefix + m_scriptsList.front() + ' ' + interestName.toUri();
        cmd = tmpString.c_str();

        if(DEBUG) std::cout << "running " << cmd << std::endl;
        
        pipe = popen(cmd, "r");
        if (!pipe) 
          std::cerr << "Unable to run " << cmd << " - is the script in the nfdDataCollection directory?" << std::endl;

        result = "";
        while(!feof(pipe)) 
        {
          if(fgets(buf, BUF_SIZE, pipe) != NULL)
            result += buf;
        }
        pclose(pipe);
        m_scriptsList.pop_front();

        if(DEBUG) std::cout <<  "Got data: " << result << std::endl;
       
        // generate data packet containing script data
        ScriptReply script_reply;
        script_reply.setData(result);
        ndn::shared_ptr<ndn::Data> data = ndn::make_shared<ndn::Data>(interestName);
        data->setContent(script_reply.wireEncode());
        data->setFreshnessPeriod(time::seconds(0));

        m_keyChain.sign(*data);
        m_face.put(*data);  
      }
    }

    void
    onRegisterFailed(const ndn::Name& prefix, const std::string& reason)
    {
      std::cerr << "ERROR: Failed to register prefix (" << reason << ")" << std::endl;
      m_face.shutdown();
    }

    void
    registerInterest()
    {
      if (DEBUG)
        std::cout << "register for prefix " << m_prefixFilter << std::endl;
      
      // Set up a handler for incoming interests
      m_face.setInterestFilter(m_prefixFilter,
                               ndn::bind(&NdnMapClient::onInterest, this, _1, _2),
                               ndn::RegisterPrefixSuccessCallback(),
                               ndn::bind(&NdnMapClient::onRegisterFailed, this, _1, _2));
    }
    
    void
    listen()
    {
      m_face.processEvents();
    }
    
    std::string&
    getProgramName()
    {
      return m_programName;
    }
    
    void
    setMyFilter(std::string filter)
    {
      std::cout << "filter: " << filter << std::endl;
      m_prefixFilter = filter;
      std::cout << "m_prefixFilter: " << m_prefixFilter << std::endl;
    }
    
    std::string&
    getFilter()
    {
      return m_prefixFilter;
    }

    void
    setBufSize(int bufSize)
    {
      BUF_SIZE = bufSize;    
    }
    
  private:
    std::string m_programName;
    std::string m_prefixFilter;
    std::unordered_set<std::string> m_remoteLinks;
    std::list<std::string> m_scriptsList;
    int m_pollPeriod;
    Face m_face;
    KeyChain m_keyChain;
    int BUF_SIZE;
  };
}

int
main(int argc, char* argv[])
{
  ndn::NdnMapClient ndnmapClient(argv[0]);
  int option;
  
  ndnmapClient.setBufSize(1024);

  while ((option = getopt(argc, argv, "hp:d:b:")) != -1)
  {
    switch (option)
    {
      case 'p':
        ndnmapClient.setMyFilter((std::string)(optarg));
        break;
        
      case 'h':
        ndnmapClient.usage();
        break;
        
      case 'd':
        DEBUG = atoi(optarg);
        break;
        
      case 'b':
        ndnmapClient.setBufSize(atoi(optarg));
        break;

      default:
        ndnmapClient.usage();
        break;
    }
  }

  argc -= optind;
  argv += optind;

  if((ndnmapClient.getFilter()).empty())
  {
    ndnmapClient.usage();
    return 1;
  }
  ndnmapClient.registerInterest();
  
  ndnmapClient.listen();
  
  return 0;
}
