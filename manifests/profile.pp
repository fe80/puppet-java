# @summary
#   Set profile file
#
# @api private
#
class java::profile {
  $homes = '/usr/lib/jvm'

  file { $java::profile:
    ensure  => $java::ensure,
    mode    => '0444',
    owner   => 'root',
    group   => 'root',
    content => template("${module_name}/java-profile.erb"),
  }
}
