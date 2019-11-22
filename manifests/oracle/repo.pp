# @summary
#   Define the external repository for oracle provider
#
# @param ensure
#   Specifies whether version is present
#
# @param mirror
#   Set mirror location (https only)
#
class java::oracle::repo (
  Enum['present', 'absent'] $ensure = $java::ensure,
  String $mirror                    = $java::mirror,
) {
  case fact('osfamily') {
    /Debian/: {
      require apt
      apt::source { 'java-oracle':
        ensure   => $ensure,
        location => $mirror,
        release  => 'debian',
        repos    => 'main',
        tag      => 'oracle-jdk',
      }
    }
    /RedHat/: {
      fail("${module_name} : Unsupported oracle jdk package fo ${facts['osfamily']}")
    }
    default: {}
  }
}
