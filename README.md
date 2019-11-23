---

[![Build Status](https://api.travis-ci.com/fe80/puppet-java.svg?branch=master)](https://travis-ci.com/fe80/puppet-java)
[![Coverage Status](https://coveralls.io/repos/github/fe80/java-package/badge.svg?branch=master)](https://coveralls.io/github/fe80/java-package?branch=master)
[![Puppet Forge](https://img.shields.io/puppetforge/v/fe80/java.svg)](https://forge.puppetlabs.com/fe80/java)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/fe80/java.svg)](https://forge.puppetlabs.com/fe80/java)

# Java module for Puppet

This module was write by fe80 <puppetlabs@p0l.io>

## Requirements

Please check `metadata.json` for the requirements

## Usage

### Basic Usage

Install lasted version of openjdk on your distribution

```puppet
include java
```

### Define versions

```puppet
class {'java':
  versions => [ 11, 8 ]
}
```

### Oracle jdk support

For supported oracle Jdk you need to define a repository.

```puppet
class {
  versions => [ 11 ],
  provider => 'oracle',
  mirror   => 'https://mymirror.com/oracle/apt',
}
```

For build java, I recommend ruby fpm package.

Need contribution for RedHat support.

## Supported OS

* Debian 8
* Ubuntu >= 16.04
* RedHat 7
* Centos 7

## Todo
* Runner for spec
* Runner for documentation
* Support Oracle jdk support for RedHat
