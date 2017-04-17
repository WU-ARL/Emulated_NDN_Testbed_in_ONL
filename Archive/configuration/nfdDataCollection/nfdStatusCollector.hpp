/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil; -*- */
/**
 * Copyright (c) 2014, Washington University in St. Louis,
 *
 */

#ifndef NFD_STATUS_COLLECTOR_H
#define NFD_STATUS_COLLECTOR_H

#include <boost/asio.hpp>
#include <ndn-cxx/encoding/buffer-stream.hpp>
#include <vector>
#include <boost/lexical_cast.hpp>

namespace ndn {
namespace statusCollector
{
  namespace tlv
  {
    enum
    {
      CollectorReply  = 128,
      FaceStatus      = 129,
      LinkIp          = 130,
      TX              = 131,
      RX              = 132,
      FaceId          = 133,
      CurrentTime     = 134,
      ScriptPacket    = 135,
      ScriptData      = 136
    };
  }
}

class FaceStatus
{
public:
  FaceStatus(){};
  explicit
  FaceStatus(const Block& status)
  {
    this->wireDecode(status);
  }
  template<bool T>
  size_t
  wireEncode(EncodingImpl<T>& encoder) const
  {
    size_t totalLength = 0;
    
    totalLength += prependNonNegativeIntegerBlock(encoder,
                                                  ndn::statusCollector::tlv::RX,
                                                  m_rx);
    
    totalLength += prependNonNegativeIntegerBlock(encoder,
                                                  ndn::statusCollector::tlv::TX,
                                                  m_tx);
    
    totalLength += prependNonNegativeIntegerBlock(encoder,
                                                  ndn::statusCollector::tlv::FaceId,
                                                  m_faceId);
    
    totalLength += prependByteArrayBlock(encoder, ndn::statusCollector::tlv::LinkIp,
                                         reinterpret_cast<const uint8_t*>(m_linkIp.c_str()), m_linkIp.size());
    
    totalLength += prependByteArrayBlock(encoder, ndn::statusCollector::tlv::CurrentTime,
                                         reinterpret_cast<const uint8_t*>(m_timestamp.c_str()), m_timestamp.size());
    
    
    totalLength += encoder.prependVarNumber(totalLength);
    totalLength += encoder.prependVarNumber(statusCollector::tlv::FaceStatus);
    return totalLength;
  }
  
  const Block&
  wireEncode() const
  {
    if (m_wire.hasWire())
      return m_wire;
    
    EncodingEstimator estimator;
    size_t estimatedSize = wireEncode(estimator);
    
    EncodingBuffer buffer(estimatedSize, 0);
    wireEncode(buffer);
    
    m_wire = buffer.block();
    return m_wire;
  }
  
  void
  wireDecode(const Block& wire)
  {
    m_tx = 0;
    m_rx = 0;
    m_faceId = 0;
    m_linkIp.empty();
    m_timestamp.empty();
    
    
    if (wire.type() != statusCollector::tlv::FaceStatus)
    {
      std::stringstream error;
      error << "Expected FaceStatus Block, but Block is of a different type: #" << wire.type();
      std::cerr << error.str() << std::endl;
    }
    
    m_wire = wire;
    m_wire.parse();
    
    Block::element_const_iterator val = m_wire.elements_begin();
    Block::element_const_iterator oldVal;
    while (val != m_wire.elements_end())
    {
      oldVal = val;

     // std::cout << "Block is of type: #" << m_wire.type() << std::endl;
      if (val != m_wire.elements_end() && val->type() == ndn::statusCollector::tlv::RX)
      {
        m_rx = readNonNegativeInteger(*val);
        ++val;
      }
      if (val != m_wire.elements_end() && val->type() == ndn::statusCollector::tlv::TX)
      {
        m_tx = readNonNegativeInteger(*val);
        ++val;
      }
      
      if (val != m_wire.elements_end() && val->type() == ndn::statusCollector::tlv::FaceId)
      {
        m_faceId = readNonNegativeInteger(*val);
        ++val;
      }
      
      if (val != m_wire.elements_end() && val->type() == ndn::statusCollector::tlv::LinkIp)
      {
        m_linkIp.assign(reinterpret_cast<const char*>(val->value()), val->value_size());
        ++val;
      }
      
      if (val != m_wire.elements_end() && val->type() == ndn::statusCollector::tlv::CurrentTime)
      {
        m_timestamp.assign(reinterpret_cast<const char*>(val->value()), val->value_size());
        ++val;
      }
      
      if(oldVal == val)
      {
        std::cout << "ERROR!!: About to exit" << std::endl;
        exit(1);
      }
    }
  }
  
  const uint64_t &
  getTx() const
  {
    return m_tx;
  }
  
  FaceStatus&
  setTx(const uint64_t& tx)
  {
    m_wire.reset();
    m_tx = tx;
    return *this;
  }
  
  const uint64_t &
  getRx() const
  {
    return m_rx;
  }
  
  FaceStatus&
  setRx(const uint64_t& rx)
  {
    m_wire.reset();
    m_rx = rx;
    return *this;
  }

  const uint64_t &
  getFaceId() const
  {
    return m_faceId;
  }

  FaceStatus&
  setFaceId(const uint64_t& faceId)
  {
    m_wire.reset();
    m_faceId = faceId;
    return *this;
  }
  
  const std::string&
  getLinkIp() const
  {
    return m_linkIp;
  }
  
  FaceStatus&
  setLinkIp(const std::string& linkIp)
  {
    m_wire.reset();
    m_linkIp = linkIp;
    return *this;
  }
  
  const std::string&
  getTimestamp() const
  {
    return m_timestamp;
  }
  
  FaceStatus&
  setTimestamp(const std::string& currentTime)
  {
    m_wire.reset();
    m_timestamp = currentTime;
    return *this;
  }
private:
  uint64_t m_tx;
  uint64_t m_rx;
  uint64_t m_faceId;
  std::string m_linkIp;
  std::string m_timestamp;
  
  mutable Block m_wire;
};

std::ostream&
operator<<(std::ostream& os, const FaceStatus& status)
{
  os << "FaceStatus("
  << "TX: " << status.getTx() << ", "
  << "RX: " << status.getRx() << ", "
  << "Face Id: " << status.getFaceId() << ", "
  << "Link Ip: " << status.getLinkIp() << ", "
  << "Current Time: " << status.getTimestamp();;
  
  os << ")";
  
  return os;
}

class CollectorData
{
public:
  void
  clear()
  {
    m_statusList.clear();
  }
  
  bool
  empty() const
  {
    return m_statusList.empty();
  }
  
  void
  add(const FaceStatus& status)
  {
    m_statusList.push_back(status);
  }
  int size()
  {
    return m_statusList.size();
  }
  
  template<bool T>
  size_t
  wireEncode(EncodingImpl<T>& encoder) const
  {
    size_t totalLength = 0;
    
    for (std::vector<FaceStatus>::const_reverse_iterator i = m_statusList.rbegin();
         i != m_statusList.rend(); ++i)
    {
      totalLength += i->wireEncode(encoder);
    }
    
   // totalLength += m_prefix.wireEncode(block);
    
    totalLength += encoder.prependVarNumber(totalLength);
    totalLength += encoder.prependVarNumber(statusCollector::tlv::CollectorReply);
    
    return totalLength;
  }
  
  Block
  wireEncode() const
  {
    Block block;
    
    EncodingEstimator estimator;
    size_t estimatedSize = wireEncode(estimator);
    
    EncodingBuffer buffer(estimatedSize);
    wireEncode(buffer);
    
    return buffer.block();
  }
  
  void
  wireDecode(const Block& wire)
  {
    m_statusList.clear();
    
    if (!wire.hasWire())
      std::cerr << "The supplied block does not contain wire format" << std::endl;
    
    if (wire.type() != statusCollector::tlv::CollectorReply)
      std::cerr << "Unexpected TLV type when decoding CollectorReply: " +
        boost::lexical_cast<std::string>(wire.type()) <<std::endl;
    
    wire.parse();
    
    for (Block::element_const_iterator it = wire.elements_begin();
         it != wire.elements_end(); it++)
    {
      if (it->type() == statusCollector::tlv::FaceStatus)
      {
        m_statusList.push_back(FaceStatus(*it));
      }
      else
        std::cerr << "No FaceStatus entry when decoding CollectorReply!!" << std::endl;
    }
  }
//private:
  std::vector<FaceStatus> m_statusList;
};

class ScriptReply 
{
public:
  ScriptReply(){};
  explicit
  ScriptReply(const Block& block)
  {
    this->wireDecode(block);
  }
  
  template<bool T>
  size_t
  wireEncode(EncodingImpl<T>& encoder) const
  {
    size_t bytes_encoded = 0;

    bytes_encoded += prependByteArrayBlock(encoder, ndn::statusCollector::tlv::ScriptData, reinterpret_cast<const uint8_t*>(m_data.c_str()), m_data.size());
    
    bytes_encoded += encoder.prependVarNumber(bytes_encoded);
    bytes_encoded += encoder.prependVarNumber(statusCollector::tlv::ScriptPacket);
    return bytes_encoded; 
  }
  
  const Block&
  wireEncode()
  {
    if (m_block.hasWire())
      return m_block;
  
    EncodingEstimator estimator;
    size_t estimatedSize = wireEncode(estimator);

    EncodingBuffer buffer(estimatedSize, 0);
    wireEncode(buffer);

    m_block = buffer.block();
    return m_block;
  }

  void
  wireDecode(const Block& block)
  {
    if (block.type() != statusCollector::tlv::ScriptPacket)
    {
      std::stringstream error;
      error << "Expected ScriptPacket block, but block is of different type: #" << block.type();
      std::cerr << error.str() << std::endl;
    }
  
    m_block = block;
    m_block.parse();

    Block::element_const_iterator val = m_block.elements_begin();
    Block::element_const_iterator oldVal; 

    while (val != m_block.elements_end())
    {
      oldVal = val;

      if (val != m_block.elements_end() && val->type() == ndn::statusCollector::tlv::ScriptData)
      {
        m_data.assign(reinterpret_cast<const char*>(val->value()), val->value_size());
        ++val;
      }
      if(oldVal == val)
      {
        std::cout << "ERROR!!: About to exit" << std::endl;
        exit(1);
      }
    } 
  }

  void
  setData(std::string& data)
  {
    m_data = data;
  }

  const std::string&
  getData() const
  {
    return m_data;
  }
  
private:
  std::string m_data;
  mutable Block m_block;

};
}
#endif
