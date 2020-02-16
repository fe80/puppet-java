# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include java::adoptopenjdk::install
class java::adoptopenjdk::install {
  $supported = [ 8, 11, 12 ,13 ]
  $java::_versions.each |Integer $version| {
    unless $version in $supported {
      fail("${module_name}: Unsupported version adoptopenjdk jdk ${version}")
    }

    package { "adoptopenjdk-${version}-openj9":
      ensure => $java::ensure,
      tag    => 'adoptopenjdk-jdk',
    }
  }
}
