#!/bin/bash

killall dhclient
sudo dhclient -cf dhclient.conf eth1 -lf dhclient.leases -d
