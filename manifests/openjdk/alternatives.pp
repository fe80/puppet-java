# @summary
#   Configure alternatives path
#
# @api private
#
class java::openjdk::alternatives {

  $beans = fact('osfamily') ? {
    'Debian' => [ 'java', 'jar', 'javac', 'jarsigner', 'javap', 'javadoc' ],
    'RedHat' => [ 'java', 'jar', 'javac' ],
  }

  $java::_versions.each |Integer $version| {

    $priority = ($version == $java::_default_version) ? {
      true    => 999999,
      default => 1000,
    }

    if fact('osfamily') == 'RedHat' {
      if versioncmp(String($version), '8') <= 0 {
        $path = "jre-1.${version}.0"
      } else {
        $path = "jre-${version}-openjdk"
      }
    } else {
      $path = "java-${version}-openjdk-amd64"
    }

    $beans.each |$bin| {
      $alt = "/usr/lib/jvm/${path}/bin/${bin}"
      alternative_entry { $alt:
        ensure   => $java::ensure,
        altlink  => "/usr/bin/${bin}",
        altname  => $bin,
        priority => $priority,
      }

      if $version == $java::_default_version {
        alternatives { $bin:
          path    => $alt,
          require => Alternative_entry[$alt],
        }
      }
    }
  }
}
