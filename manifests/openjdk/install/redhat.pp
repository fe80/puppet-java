# @summary
#   Install openjdk on RedHat family
#
# @example Install version 11
#   java::openjdk::install::redhat {
#     version => 11,
#   }
#
# @param version
#   Version to install
#
# @param ensure
#   Specifies whether version is present
define java::openjdk::install::redhat(
  Integer $version                  = undef,
  Enum['present', 'absent'] $ensure = 'present',
) {

  $supported = $facts['operatingsystemmajrelease'] ? {
    '6'     => [ 5, 6, 7, 8 ],
    '7'     => [ 6, 7, 8, 11 ],
    default => [],
  }

  unless $version in $supported {
    fail("${module_name}: Unsupported version ${version} for ${facts['osfamily']} family ${facts['operatingsystemmajrelease']}")
  }

  if versioncmp(String($version), '8') <= 0 {
    $package_name = "java-1.${version}.0-openjdk"
  } else {
    $package_name = "java-${version}-openjdk"
  }

  package { $package_name:
    ensure => $ensure,
    tag    => 'openjdk',
  }
}
