puppet-install-shell
====================

A shell script to install puppet on multiple distros, assuming no dependancies.

The code is a mashup of [puppet-bootstrap](https://github.com/hashicorp/puppet-bootstrap) and [chef's install.sh script](https://www.getchef.com/chef/install.sh).

Usage
```
$ ./puppet.sh [-p] [-v version] [-f filename | -d download_dir]
```

Defaults to 3.4.2 as a version if none is given.

Currently working on: Debian, CentOS.
