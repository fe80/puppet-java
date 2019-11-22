# @summary
#   Openjdk install class
#
# @api private
#
class java::openjdk::install {
  case $facts['osfamily'] {
    'Debian': {
      $java::_versions.each |Integer $version| {
        java::openjdk::install::debian { "openjdk-${version}":
          ensure  => $java::ensure,
          version => $version,
        }
      }
    }
    'Redhat': {
      $java::_versions.each |Integer $version| {
        java::openjdk::install::redhat { "openjdk-${version}":
          ensure  => $java::ensure,
          version => $version,
        }
      }
    }
    default: {}
  }
}
