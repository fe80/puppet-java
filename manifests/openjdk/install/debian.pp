# @summary
#   Install openjdk on Debian family
#
# @example Install version 11
#   java::openjdk::install::debian {
#     version => 11,
#   }
#
# @param version
#   Version to install
#
# @param ensure
#   Specifies whether version is present
define java::openjdk::install::debian (
  Integer $version                  = undef,
  Enum['present', 'absent'] $ensure = 'present',
) {

  $supported = $facts['operatingsystemmajrelease'] ? {
    '8'     => [ 7 ],
    '14.04' => [ 6 ],
    '16.04' => [ 8, 9 ],
    '18.04' => [ 8, 11 ],
    default => [],
  }

  unless $version in $supported {
    fail("${module_name} : Unsupported version ${version} for ${facts['osfamily']} ${facts['operatingsystemmajrelease']}")
  }

  $package_name = "openjdk-${version}-jdk"

  package { $package_name:
    ensure => $ensure,
    tag    => 'openjdk',
  }
}
