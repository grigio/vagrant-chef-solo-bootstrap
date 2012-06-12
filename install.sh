#!/bin/bash

# This runs as root on the server

chef_binary=/usr/local/bin/chef-solo

# Are we on a vanilla system?
if ! test -f "$chef_binary"; then
    export DEBIAN_FRONTEND=noninteractive
    # Install Ruby and Chef
    aptitude update &&
    aptitude install -y \
      ruby1.9.1 ruby1.9.1-dev build-essential make automake autoconf \
      wget ssl-cert curl &&
    sudo gem1.9.1 install --no-rdoc --no-ri chef --version 0.10.10
fi &&

"$chef_binary" -c solo.rb -j solo.json
