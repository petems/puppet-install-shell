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

# Get command line arguments
while getopts pv:f:d:P: opt
do
  case "$opt" in

    v)  version="$OPTARG";;
    p)  prerelease="true";;
    f)  cmdline_filename="$OPTARG";;
    P)  project="$OPTARG";;
    d)  cmdline_dl_dir="$OPTARG";;
    \?)   # unknown flag
      echo >&2 \
      "usage: $0 [-p] [-v version] [-f filename | -d download_dir]"
      exit 1;;
  esac
done
shift `expr $OPTIND - 1`

machine=`uname -m`
os=`uname -s`
