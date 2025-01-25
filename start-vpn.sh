#!/bin/bash

# Enable IP forwarding
sysctl -w net.ipv4.ip_forward=1

# Configure iptables
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o eth0 -j MASQUERADE

# Start strongSwan
ipsec start --nofork
