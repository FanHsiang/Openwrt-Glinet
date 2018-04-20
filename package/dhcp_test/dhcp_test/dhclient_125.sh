#!/bin/bash

killall dhclient
sudo dhclient -cf dhclient_125.conf eth1 -lf dhclient.leases -d
