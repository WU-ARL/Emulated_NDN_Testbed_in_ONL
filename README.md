# Emulated_NDN_Testbed_in_ONL

This repo contains several examples of an emulated NDN Testbed in ONL.
These examples come in different sizes to make it easier for beginners to
try it out:

(Right now, the Full_Testbed is the only one supported. We are working on the others.)

Eastern_US_Only: contains just the gateway routers from the Eastern US (NEU, Michigan, Illinois, WU, Memphis and NIST)
US_Only: contains just the gateway routers from the US
Full_Testbed: contains the full NDN Testbed.

Each example contains its own ONL RLI topology file and Ansible configuration files.
Full_Testbed/Full_Testbed.onl

More description and documentation is coming soon.

Note: Some of these ONL topologies use a hardware type that is not built into the RLI.
      You may need to copy the files in ONL.HW.Files into your ~/.onldir directory
      to get the topologies to load.
