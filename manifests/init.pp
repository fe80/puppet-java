# @summary
#   Install java jdk package.
# @example Puppet usage
#   class { 'java':
#     provider => 'openjdk',
#     versions => [ 11 ],
#   }
#
# @example Hiera class (classes.yaml)
#   ---
#   classes:
#     - java
#
# @example Hiera params (params.yaml)
#   java::versions:
#     - 11
#
# @param ensure
#   Define if class must be ensure or absent
#
# @param provider
#   Define the provider type, openjdk type use distrib package.
#
# @param versions
#   List jdk versions needed
#
# @param default_version
#   Specifies the default version, default is the first versions match
#
# @param collectd
#   Include the GenericJMX collectd class
class java (
  Enum['present', 'absent'] $ensure                   = 'present',
  Enum['openjdk', 'oracle', 'adoptopenjdk'] $provider = 'openjdk',
  Optional[Tuple[Integer, 1, default]] $versions      = undef,
  Optional[Integer] $default_version                  = undef,
  Optional[String] $mirror                            = undef
) inherits java::params {

  if $provider == 'openjdk' {

    include java::openjdk::params
    $_versions = pick($versions, [$java::openjdk::params::versions[0]])

  } elsif $provider == 'oracle' {

    $_versions = pick($versions, [ 8 ])

  } elsif $provider == 'adoptopenjdk' {
    $_versions = pick($versions, [ 13 ])
  }

  $_default_version = $default_version ? {
    undef   => $_versions[0],
    default => $default_version,
  }

  include "java::${provider}"

  include java::profile
  include java::default
}
