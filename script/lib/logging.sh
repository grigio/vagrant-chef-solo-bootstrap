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
  echo -e "$RED[ERROR]$RESET $@"
}

log_prepend () {
  while read line ; do
    echo -e "$BLUE[$1]$RESET $line"
  done
}
