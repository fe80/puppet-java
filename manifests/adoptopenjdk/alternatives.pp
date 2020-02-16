# @summary Managed Adoptopenjdk alternatives
#
# @api private
#
class java::adoptopenjdk::alternatives {
  $java::_versions.each |Integer $version| {
    $priority = ($version == $java::_default_version) ? {
      true    => 999999,
      default => 1000,
    }

    $beans = [ 'java', 'jar', 'javac' ]

    $beans.each |$bin| {
      $alt = "/usr/lib/jvm/adoptopenjdk-${version}-openj9/bin/${bin}"
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
