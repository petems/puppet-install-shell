#!/bin/sh
# WARNING: REQUIRES /bin/sh
#
# Install Puppet with shell... how hard can it be?
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
    warn "There is no utopic release yet, and it's now EOL";
    warn "Recomend updating, but we'll use the trusty package for now: http://fridge.ubuntu.com/2015/07/03/ubuntu-14-10-utopic-unicorn-reaches-end-of-life-on-july-23-2015/";
    ubuntu_codename="trusty";
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

# Helper bug-reporting text
report_bug() {
  critical "Please file a bug report at https://github.com/petems/puppet-install-shell/"
  critical ""
  critical "Version: $version"
  critical "Platform: $platform"
  critical "Platform Version: $platform_version"
  critical "Machine: $machine"
  critical "OS: $os"
  critical ""
  critical "Please detail your operating system type, version and any other relevant details"
}

# Get command line arguments
while getopts v:f:d:h opt
do
  case "$opt" in
    v)  version="$OPTARG";;
    f)  cmdline_filename="$OPTARG";;
    d)  cmdline_dl_dir="$OPTARG";;
    h) echo >&2 \
      "install_puppet.sh - A shell script to install Puppet, assuming no dependencies
      usage:
      -v   version         version to install, defaults to \$latest_version
      -f   filename        filename for downloaded file, defaults to original name
      -d   download_dir    filename for downloaded file, defaults to /tmp/(random-number)"
      exit 0;;
    \?)   # unknown flag
      echo >&2 \
      "unknown option
      usage: $0 [-v version] [-f filename | -d download_dir]"
      exit 1;;
  esac
done
shift `expr $OPTIND - 1`

machine=`uname -m`
os=`uname -s`

# Retrieve Platform and Platform Version
if test -f "/etc/lsb-release" && grep -q DISTRIB_ID /etc/lsb-release; then
  platform=`grep DISTRIB_ID /etc/lsb-release | cut -d "=" -f 2 | tr '[A-Z]' '[a-z]'`
  platform_version=`grep DISTRIB_RELEASE /etc/lsb-release | cut -d "=" -f 2`
elif test -f "/etc/debian_version"; then
  platform="debian"
  platform_version=`cat /etc/debian_version`
elif test -f "/etc/redhat-release"; then
  platform=`sed 's/^\(.\+\) release.*/\1/' /etc/redhat-release | tr '[A-Z]' '[a-z]'`
  platform_version=`sed 's/^.\+ release \([.0-9]\+\).*/\1/' /etc/redhat-release`

  #If /etc/redhat-release exists, we act like RHEL by default. Except for fedora
  if test "$platform" = "fedora"; then
    platform="fedora"
  else
    platform="el"
  fi
elif test -f "/etc/system-release"; then
  platform=`sed 's/^\(.\+\) release.\+/\1/' /etc/system-release | tr '[A-Z]' '[a-z]'`
  platform_version=`sed 's/^.\+ release \([.0-9]\+\).*/\1/' /etc/system-release | tr '[A-Z]' '[a-z]'`
  # amazon is built off of fedora, so act like RHEL
  if test "$platform" = "amazon linux ami"; then
    critical "Amazon Linux can't install older Puppet: Puppet 4 works fine on Amazon Linux"
    report_bug
    exit 1
  fi
# Apple OS X
elif test -f "/usr/bin/sw_vers"; then
  platform="mac_os_x"
  # Matching the tab-space with sed is error-prone
  platform_version=`sw_vers | awk '/^ProductVersion:/ { print $2 }'`

  major_version=`echo $platform_version | cut -d. -f1,2`
  case $major_version in
    "10.6") platform_version="10.6" ;;
    "10.7"|"10.8"|"10.9"|"10.10") platform_version="10.7" ;;
    *) echo "No builds for platform: $major_version"
       report_bug
       exit 1
       ;;
  esac

  # x86_64 Apple hardware often runs 32-bit kernels (see OHAI-63)
  x86_64=`sysctl -n hw.optional.x86_64`
  if test $x86_64 -eq 1; then
    machine="x86_64"
  fi
elif test -f "/etc/release"; then
  platform="solaris2"
  machine=`/usr/bin/uname -p`
  platform_version=`/usr/bin/uname -r`
elif test -f "/etc/SuSE-release"; then
  if grep -q 'Enterprise' /etc/SuSE-release;
  then
      platform="sles"
      platform_version=`awk '/^VERSION/ {V = $3}; /^PATCHLEVEL/ {P = $3}; END {print V "." P}' /etc/SuSE-release`
  else
      platform="suse"
      platform_version=`awk '/^VERSION =/ { print $3 }' /etc/SuSE-release`
  fi
elif test -f "/etc/arch-release"; then
  platform="archlinux"
  platform_version=`/usr/bin/uname -r`
elif test "x$os" = "xFreeBSD"; then
  platform="freebsd"
  platform_version=`uname -r | sed 's/-.*//'`
elif test "x$os" = "xAIX"; then
  platform="aix"
  platform_version=`uname -v`
  machine="ppc"
fi

if test "x$platform" = "x"; then
  critical "Unable to determine platform version!"
  report_bug
  exit 1
fi

if test "x$version" = "x"; then
  version="latest";
  info "Version parameter not defined, assuming latest";
else
  case "$version" in
    4*)
      critical "Cannot install Puppet >= 4 with this script, you need to use install_puppet_agent.sh"
      report_bug
      exit 1
      ;;
    *)
      info "Version parameter defined: $version";
      ;;
  esac
fi

# Mangle $platform_version to pull the correct build
# for various platforms
major_version=`echo $platform_version | cut -d. -f1`
case $platform in
  "el")
    platform_version=$major_version
    ;;
  "fedora")
    platform_version=$major_version
    case $platform_version in  #See http://docs.puppetlabs.com/guides/puppetlabs_package_repositories.html#for-fedora
      "20") platform_version="20";;
      *) info "Puppet only offers an official repo for Puppet 3.X for Fedora 20, so using that repo"
         platform_version="20";;
    esac
    ;;
  "debian")
    case $major_version in
      "5") platform_version="6";;
      "6") platform_version="6";;
      "7") platform_version="6";;
    esac
    ;;
  "freebsd")
    platform_version=$major_version
    ;;
  "sles")
    platform_version=$major_version
    ;;
  "suse")
    platform_version=$major_version
    ;;
esac

if test "x$platform_version" = "x"; then
  critical "Unable to determine platform version!"
  report_bug
  exit 1
fi

if test "x$platform" = "xsolaris2"; then
  # hack up the path on Solaris to find wget
  PATH=/usr/sfw/bin:$PATH
  export PATH
fi

checksum_mismatch() {
  critical "Package checksum mismatch!"
  report_bug
  exit 1
}

unable_to_retrieve_package() {
  critical "Unable to retrieve a valid package!"
  report_bug
  exit 1
}

random_hexdump () {
  hexdump -n 2 -e '/2 "%u"' /dev/urandom
}

if test "x$TMPDIR" = "x"; then
  tmp="/tmp"
else
  tmp=$TMPDIR
fi

# Random function since not all shells have $RANDOM
if exists hexdump; then
  random_number=random_hexdump
else
  random_number=`date +%N`
fi

tmp_dir="$tmp/install.sh.$$.$random_number"
(umask 077 && mkdir $tmp_dir) || exit 1

tmp_stderr="$tmp/stderr.$$.$random_number"

capture_tmp_stderr() {
  # spool up tmp_stderr from all the commands we called
  if test -f $tmp_stderr; then
    output=`cat ${tmp_stderr}`
    stderr_results="${stderr_results}\nSTDERR from $1:\n\n$output\n"
  fi
}

trap "rm -f $tmp_stderr; rm -rf $tmp_dir; exit $1" 1 2 15

# do_wget URL FILENAME
do_wget() {
  info "Trying wget..."
  wget -O "$2" "$1" 2>$tmp_stderr
  rc=$?

  # check for 404
  grep "ERROR 404" $tmp_stderr 2>&1 >/dev/null
  if test $? -eq 0; then
    critical "ERROR 404"
    unable_to_retrieve_package
  fi

  # check for bad return status or empty output
  if test $rc -ne 0 || test ! -s "$2"; then
    capture_tmp_stderr "wget"
    return 1
  fi

  return 0
}

# do_curl URL FILENAME
do_curl() {
  info "Trying curl..."
  curl -1 -sL -D $tmp_stderr "$1" > "$2"
  rc=$?
  # check for 404
  grep "404 Not Found" $tmp_stderr 2>&1 >/dev/null
  if test $? -eq 0; then
    critical "ERROR 404"
    unable_to_retrieve_package
  fi

  # check for bad return status or empty output
  if test $rc -ne 0 || test ! -s "$2"; then
    capture_tmp_stderr "curl"
    return 1
  fi

  return 0
}

# do_fetch URL FILENAME
do_fetch() {
  info "Trying fetch..."
  fetch -o "$2" "$1" 2>$tmp_stderr
  # check for bad return status
  test $? -ne 0 && return 1
  return 0
}

# do_perl URL FILENAME
do_perl() {
  info "Trying perl..."
  perl -e 'use LWP::Simple; getprint($ARGV[0]);' "$1" > "$2" 2>$tmp_stderr
  rc=$?
  # check for 404
  grep "404 Not Found" $tmp_stderr 2>&1 >/dev/null
  if test $? -eq 0; then
    critical "ERROR 404"
    unable_to_retrieve_package
  fi

  # check for bad return status or empty output
  if test $rc -ne 0 || test ! -s "$2"; then
    capture_tmp_stderr "perl"
    return 1
  fi

  return 0
}

do_checksum() {
  if exists sha256sum; then
    checksum=`sha256sum $1 | awk '{ print $1 }'`
    if test "x$checksum" != "x$2"; then
      checksum_mismatch
    else
      info "Checksum compare with sha256sum succeeded."
    fi
  elif exists shasum; then
    checksum=`shasum -a 256 $1 | awk '{ print $1 }'`
    if test "x$checksum" != "x$2"; then
      checksum_mismatch
    else
      info "Checksum compare with shasum succeeded."
    fi
  elif exists md5sum; then
    checksum=`md5sum $1 | awk '{ print $1 }'`
    if test "x$checksum" != "x$3"; then
      checksum_mismatch
    else
      info "Checksum compare with md5sum succeeded."
    fi
  elif exists md5; then
    checksum=`md5 $1 | awk '{ print $4 }'`
    if test "x$checksum" != "x$3"; then
      checksum_mismatch
    else
      info "Checksum compare with md5 succeeded."
    fi
  else
    warn "Could not find a valid checksum program, pre-install shasum, md5sum or md5 in your O/S image to get valdation..."
  fi
}

# do_download URL FILENAME
do_download() {
  info "Downloading $1"
  info "  to file $2"

  # we try all of these until we get success.
  # perl, in particular may be present but LWP::Simple may not be installed

  if exists wget; then
    do_wget $1 $2 && return 0
  fi

  if exists curl; then
    do_curl $1 $2 && return 0
  fi

  if exists fetch; then
    do_fetch $1 $2 && return 0
  fi

  if exists perl; then
    do_perl $1 $2 && return 0
  fi

  unable_to_retrieve_package
}

# install_puppet_package TYPE
# TYPE is "rpm", "deb", "solaris", or "sh"
install_puppet_package() {
  case "$1" in
    "rpm")
      if test "$version" = 'latest'; then
        yum install -y puppet
      else
        yum install -y "puppet-$version"
      fi
      ;;
    "deb")
      apt-get update -y
      if test "$version" = 'latest'; then
        apt-get install -y puppet-common puppet
      else
        case $platform in
          "ubuntu")
            version_string="$version-1puppetlabs1"
            facter_string="1.7.4-1puppetlabs1"
          ;;
          "debian")
            case $deb_codename in
              "jessie")
                version_string="$version"
                facter_string="1.7.4"
                ;;
              *)
                version_string="$version-1puppetlabs1"
                facter_string="1.7.4-1puppetlabs1"
                ;;
             esac
            ;;
          esac
        case "$version" in
          [^2.7.]*)
            info "2.7.* Puppet deb package tied to Facter < 2.0.0, specifying Facter 1.7.4"
            apt-get install -y puppet-common=$version_string puppet=$version_string facter=$facter_string --force-yes
            ;;
          *)
            apt-get install -y puppet-common=$version_string puppet=$version_string --force-yes
            ;;
        esac
      fi
      ;;
    "solaris")
      info "installing with pkgadd..."
      echo "conflict=nocheck" > /tmp/nocheck
      echo "action=nocheck" >> /tmp/nocheck
      echo "mail=" >> /tmp/nocheck
      pkgrm -a /tmp/nocheck -n puppet >/dev/null 2>&1 || true
      pkgadd -n -d "$2" -a /tmp/nocheck puppet
      ;;
    "sh" )
      info "installing with sh..."
      sh "$2"
      ;;
    "dmg" )
      info "installing with installer..."
      hdiutil attach $2
      info "Installer may require sudo access, the script might ask for your root password"
      sudo installer -verboseR -target / -package /Volumes/puppet-${version}/puppet-${version}.pkg
      # code via stackoverflow, woot -- installer might not be done at exit
      # http://stackoverflow.com/questions/18752257/delay-from-osx-installer
      flag=1
      while [ $flag -ne 0 ]
          do
              sleep 1
              hdiutil unmount /Volumes/puppet-${version}
              flag=$?
              gem install facter
              gem install hiera
          done
      ;;
    *)
      critical "Unknown filetype: $1"
      report_bug
      exit 1
      ;;
  esac
  if test $? -ne 0; then
    critical "Installation failed"
    report_bug
    exit 1
  fi
}

install_puppetlabs_repo() {
  case "$1" in
    "rpm")
      info "installing puppetlabs yum repo with rpm..."
      rpm -Uvh --oldpackage --replacepkgs "$2"
      ;;
    "deb")
      info "installing puppetlabs apt repo with dpkg..."
      dpkg -i "$2"
      ;;
    *)
      critical "Unknown filetype: $1"
      report_bug
      exit 1
      ;;
  esac
  if test $? -ne 0; then
    critical "Installation failed"
    report_bug
    exit 1
  fi
}

#Platforms that do not need downloads are in *, the rest get their own entry.
case $platform in
  "archlinux")
    info "Installing Puppet $version for arch linux..."
    if test "$version" = "latest"; then
      pacman -Sy --noconfirm community/puppet
    else
      warn "In Arch, the version only guarantees that you are installing the correct version."
      pacman -Sy --noconfirm "community/puppet>=$version"
    fi
    ;;
  "freebsd")
    info "Installing Puppet $version for FreeBSD..."
    if test "$version" != "latest"; then
      warn "In FreeBSD installation of older versions is not possible. Version is set to latest."
    fi
    case $major_version in
      "9")
        have_pkg=`grep -sc '^WITH_PKGNG' /etc/make.conf`
        if test "$have_pkg" = 1; then
          pkg install -y sysutils/puppet
        else
          pkg_add -rF puppet
        fi
        ;;
      "10")
        pkg install -y sysutils/puppet
        ;;
      *)
        critical "Sorry FreeBSD $major_version is not supported yet!"
        report_bug
        exit 1
        ;;
    esac
    ;;
  *)
    info "Downloading Puppet $version for ${platform}..."
    case $platform in
      "el")
        info "Red hat like platform! Lets get you an RPM..."
        filetype="rpm"
        filename="puppetlabs-release-el-${platform_version}.noarch.rpm"
        download_url="http://yum.puppetlabs.com/${filename}"
        ;;
      "fedora")
        info "Fedora platform! Lets get the RPM..."
        filetype="rpm"
        filename="puppetlabs-release-fedora-${platform_version}.noarch.rpm"
        download_url="http://yum.puppetlabs.com/${filename}"
        ;;
      "debian")
        info "Debian platform! Lets get you a DEB..."
        case $major_version in
          "5") deb_codename="lenny";;
          "6") deb_codename="squeeze";;
          "7") deb_codename="wheezy";;
          "8") deb_codename="jessie"; warn "Puppet only offers Puppet 4 packages for Jessie, so only 3.7.2 package avaliable"
          no_puppetlab_repo_download='yes';;
        esac
        filetype="deb"
        filename="puppetlabs-release-${deb_codename}.deb"
        download_url="http://apt.puppetlabs.com/${filename}"
        ;;
      "ubuntu")
        info "Ubuntu platform! Lets get you a DEB..."
        case $platform_version in
          "12.04") ubuntu_codename="precise";;
          "12.10") ubuntu_codename="quantal";;
          "13.04") ubuntu_codename="raring";;
          "13.10") ubuntu_codename="saucy";;
          "14.04") ubuntu_codename="trusty";;
          "16.04") warn "Puppet only offers Puppet 4 packages for Xenial, so only 3.7.2 package avaliable"
          no_puppetlab_repo_download="yes";;
          "14.10") utopic;;
        esac
        filetype="deb"
        filename="puppetlabs-release-${ubuntu_codename}.deb"
        download_url="http://apt.puppetlabs.com/${filename}"
        ;;
      "mac_os_x")
        no_puppetlab_repo_download='yes'
        info "Mac OS X platform! You need some DMGs..."
        filetype="dmg"
        if test "$version" = ''; then
          version="3.8.4";
          info "No version given, will assumed you want the latest as of 19-Feb-2014 $version";
          info "If a new version has been released, open an issue https://github.com/petems/puppet-install-shell/";
        else
          info "Downloading $version dmg file";
        fi
        filename="puppet-${version}.dmg"
        download_url="http://downloads.puppetlabs.com/mac/${filename}"
        ;;
      *)
        critical "Sorry $platform is not supported yet!"
        report_bug
        exit 1
        ;;
    esac

    if test "x$cmdline_filename" != "x"; then
      download_filename=$cmdline_filename
    else
      download_filename=$filename
    fi

    if test "x$cmdline_dl_dir" != "x"; then
      download_filename="$cmdline_dl_dir/$download_filename"
    else
      download_filename="$tmp_dir/$download_filename"
    fi

    if test "x$no_puppetlab_repo_download" != "x"; then
      warn 'Skipping download of Puppet repository, using distro upstream instead'
    else
      do_download "$download_url"  "$download_filename"
      install_puppetlabs_repo $filetype "$download_filename"
    fi
    
    if [ "$platform" == "mac_os_x" ];then
        do_download "$download_url"  "$download_filename"
        install_puppet_package $filetype "$download_filename"
    else
        install_puppet_package $filetype
    fi
    ;;
esac

#Cleanup
if test "x$tmp_dir" != "x"; then
  rm -r "$tmp_dir"
fi

