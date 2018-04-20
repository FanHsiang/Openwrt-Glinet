#!/bin/bash

killall dhclient
sudo dhclient -cf dhclient_60.conf eth1 -lf dhclient.leases -d
