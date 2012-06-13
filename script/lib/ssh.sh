remote_bash () {
  local user_at_host="$1"
  local commands=`printf "\n%s" "${@:2}"`
  local user=`echo $user_at_host | sed -e s/@.*//`
  local host=`echo $user_at_host | sed -e s/.*@//`

  local port="22"
  local key_opt=""

  [[ $host == "vagrant" ]] &&
    local host="127.0.0.1" &&
    local port="2222" &&
    local key_opt="-i $HOME/.vagrant.d/insecure_private_key" &&
    # The host key might change when we instantiate a new VM, so
    # we remove (-R) the old host key from known_hosts
    ssh-keygen -R "${host#*@}" 2> /dev/null

  local logging_code='
RESET="\x1b[0m"
BLUE="\x1b[34;01m"
CYAN="\x1b[36;01m"
GREEN="\x1b[32;01m"
RED="\x1b[31;01m"
GRAY="\x1b[37;01m"
YELLOW="\x1b[33;01m"

info () {
  echo -e "$GREEN[INFO]$RESET $@"
}

error () {
  echo -e "$GREEN[ERROR]$RESET $@"
}
  '

  info "connecting to $user@$host"
  ssh -p "$port" -o 'StrictHostKeyChecking no' $key_opt "$user@$host" \
    "$logging_code
     $commands" 2>&1 | log_prepend "SSH"
  info "disconnected from $user@$host"
}
