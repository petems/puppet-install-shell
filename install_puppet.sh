#!/bin/sh
#

# Set up colours
if tty -s;then
    RED=${RED:-$(tput setaf 1)}
    GREEN=${GREEN:-$(tput setaf 2)}
    YLW=${YLW:-$(tput setaf 3)}
    BLUE=${BLUE:-$(tput setaf 4)}
    RESET=${RESET:-$(tput sgr0)}
else
    RED=
    GREEN=
    YLW=
    BLUE=
    RESET=
fi

# Timestamp
now () {
    date +'%H:%M:%S %z'
}

# Logging functions instead of echo
log () {
    echo "${BLUE}`now`${RESET} ${1}"
}

info () {
    log "${GREEN}INFO${RESET}: ${1}"
}

warn () {
    log "${YLW}WARN${RESET}: ${1}"
}

critical () {
    log "${RED}CRIT${RESET}: ${1}"
}

# Check whether a command exists - returns 0 if it does, 1 if it does not
exists() {
  if command -v $1 >/dev/null 2>&1
  then
    return 0
  else
    return 1
  fi
}

# Helper eol text
report_eol() {
  critical "Puppet 3 is no longer hosted as a repo by Puppet"
  critical "More details here: https://groups.google.com/forum/#!topic/puppet-users/cCsGWKunBe4"
  critical ""
  critical "Puppet 3 has been EOL since December 2016"
  critical ""
  critical "You may download Puppet 3 manually from the archive repos"
  critical "eg. 'wget http://release-archives.puppet.com/yum/el/7/products/x86_64/puppet-3.8.7-1.el7.noarch.rpm && rpm -ivh puppet-3.8.7-1.el7.noarch.rpm'"
}

report_eol
exit 1
