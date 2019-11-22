---
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

For supported oracle Jdk you need to define a repository

```puppet
class {
  versions => [ 11 ],
  provider => 'oracle',
  mirror   => 'https://mymirror.com/oracle/apt',
}
```

Need contribution for RedHat support

## Supported OS

* Debian 8
* Ubuntu >= 16.04
* RedHat 7
* Centos 7

## Todo
* Runner for spec
* Runner for documentation
* Support Oracle jdk support for RedHat
