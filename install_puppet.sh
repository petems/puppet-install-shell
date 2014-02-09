#!/bin/sh
# WARNING: REQUIRES /bin/sh
#
# Install Puppet with shell... how hard can it be?
#
# 0.0.1a - Here Be Dragons
#

# Check whether a command exists - returns 0 if it does, 1 if it does not
exists() {
  if command -v $1 >/dev/null 2>&1
  then
    return 0
  else
    return 1
  fi
}
