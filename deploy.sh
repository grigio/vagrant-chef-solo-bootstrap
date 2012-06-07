#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Usage: ./deploy.sh (HOST|vagrant)
: ${1?"Usage: $0 HOST"}
host="$1"
port="22"
key_opt=""

if [[ $host == "vagrant" ]]; then
  host="vagrant@127.0.0.1"
  port="2222"
  key_opt="-i $HOME/.vagrant.d/insecure_private_key"
fi

# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
ssh-keygen -R "${host#*@}" 2> /dev/null

tar cj . | ssh -p "$port" -o 'StrictHostKeyChecking no' $key_opt "$host" '
sudo rm -rf ~/chef &&
mkdir ~/chef &&
cd ~/chef &&
tar xj &&
sudo bash install.sh'
