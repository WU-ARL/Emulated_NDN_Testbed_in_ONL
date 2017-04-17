# Emulated_NDN_Testbed_in_ONL
ICN demo of emulated NDN Testbed in ONL with data collection

Topology file for loading into the ONL RLI is in ONL_RLI_Files/NDNTestbed26.

If you ever change either of these two files in the configuration directory: routers, template.conf
then you will to re-generate the NLSR configuration files.
To do that do this:
> cd configuration/NLSR_CONF
> python setup_conf.py

Then you need to load the topology into the RLI, make a reservation and commit.

Once the commit is completed you are ready to start the daemons.
To do that run this:
> cd configuration
> ./runAll.sh

There seems to be a problem with nlsr right now that it doesn't always start the first time.
We are working on cleaning that up. For now it is started from a script, start_nlsr.sh,
that will attempt to restart it if it dies. Because of this, you will need to wait a bit, maybe
a few minutes for things to stabilize.




