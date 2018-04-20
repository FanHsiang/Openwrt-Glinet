#!/bin/bash

killall dhclient
sudo dhclient -cf dhclient_61_type255.conf eth1 -lf dhclient.leases -d
