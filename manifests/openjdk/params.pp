# @summary
#   Params class.
#
# @api private
#
class java::openjdk::params {
  case $facts['operatingsystem'] {
    'Debian': {
      $versions = [ 7 ]
    }
    'Ubuntu': {
      if versioncmp($facts['operatingsystemmajrelease'], '18.04') >= 0 {
        $versions = [ 11 ]
      } else {
        $versions = [ 8 ]
      }
    }
    'Centos', 'RedHat': {
      if versioncmp($facts['operatingsystemmajrelease'], '7') >= 0 {
        $versions = [ 11 ]
      } else {
        $versions = [ 8 ]
      }
    }

    default: {
      fail("Module ${module_name}: Unsupported OS ${facts['operatingsystem']}")
    }
  }
}
