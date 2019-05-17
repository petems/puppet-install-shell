#!/bin/sh
# WARNING: REQUIRES /bin/sh
#
# Install puppet-agent with shell... how hard can it be?
#
# 0.0.1a - Here Be Dragons
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

utopic () {
    warn "There is no utopic release yet, see https://tickets.puppetlabs.com/browse/CPR-92 for progress";
    warn "We'll use the trusty package for now";
    deb_codename="trusty";
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

# Report EOL
report_eol() {
  critical "Puppet 4 is no longer hosted as a repo by Puppet"
  critical "More details here: https://groups.google.com/forum/#!topic/puppet-users/cCsGWKunBe4"
  critical ""
  critical ""
  critical "You may download Puppet manually from the archive repos http://release-archives.puppet.com"
  critical "eg. 'wget http://release-archives.puppet.com/yum/el/7/PC1/x86_64/puppet-agent-1.10.9-1.el7.x86_64.rpm && rpm -ivh puppet-agent-1.10.9-1.el7.x86_64.rpm'"
}

report_eol
exit 1
