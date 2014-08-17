puppet-install-shell
====================

[![Build Status](https://travis-ci.org/petems/puppet-install-shell.png)](https://travis-ci.org/petems/puppet-install-shell)

A shell script to install puppet on multiple distros, assuming no dependencies.

The code is a mashup of [puppet-bootstrap](https://github.com/hashicorp/puppet-bootstrap) and [chef's install.sh script](https://www.getchef.com/chef/install.sh).

Usage
```
$ ./puppet.sh [-p] [-v version] [-f filename | -d download_dir]
```

Defaults to latest available as a version if none is given.

Currently working on: Debian, CentOS.

A quick way to install after carefully looking at the source:
```
$ wget -O - https://raw.githubusercontent.com/petems/puppet-install-shell/master/install_puppet.sh | sudo sh
```
