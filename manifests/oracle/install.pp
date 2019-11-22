# @summary This class install oracle jdk package
#
# @api private
#
class java::oracle::install {

  $supported = [
    5,
    6,
    7,
    8,
  ]

  $java::_versions.each |Integer $version| {
    unless $version in $supported {
      fail("${module_name} : Unsupported version oracle jdk ${version}")
    }
    package { "oracle-java${version}-jdk":
      ensure => $java::ensure,
      tag    => 'oracle-jdk',
    }
  }
}
