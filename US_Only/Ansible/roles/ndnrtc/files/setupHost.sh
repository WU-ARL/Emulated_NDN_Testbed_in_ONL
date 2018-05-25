#!/bin/bash

sudo cp libconfig++.so.9 /usr/lib/x86_64-linux-gnu/
sudo cp libndn-cpp.so.0 /usr/lib/x86_64-linux-gnu/

./certHost.sh

