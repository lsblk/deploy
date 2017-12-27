#!/bin/bash
ip addr add 10.141.33.83/24 dev ens3
ip route add default via 10.141.0.1
