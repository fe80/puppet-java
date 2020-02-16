#
# @summary Managed etc default file
#
# @api private
class java::default {
  assert_private()

  $java::_versions.each |Integer $version| {
    file { "/etc/default/java-${version}":
      ensure  => present,
      mode    => '0444',
      owner   => 'root',
      group   => 'root',
      content => template("${module_name}/default.erb")
    }
  }

  $default_target = "/etc/default/java-${::java::_default_version}"

  file { '/etc/default/java':
    ensure  => 'link',
    target  => $default_target,
    require => File[$default_target],
  }
}
