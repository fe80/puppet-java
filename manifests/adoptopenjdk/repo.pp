# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include s_java::adoptopenjdk::repo
class java::adoptopenjdk::repo {
  assert_private()

  case $facts['osfamily'] {
    'RedHat': {
      $_dist = $facts['os']['name'] ? {
        'RedHat' => 'rhel',
        default  => downcase($facts['os']['name']),
      }

      yumrepo { 'adoptopenjdk':
        ensure   => $java::ensure,
        name     => $_dist,
        descr    => 'Adoptopenjdk repository',
        baseurl  => "https://adoptopenjdk.jfrog.io/adoptopenjdk/rpm/${_dist}/${facts['os']['release']['major']}/${facts['os']['architecture']}",
        gpgkey   => 'https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public',
        enabled  => '1',
        gpgcheck => '1',
        target   => '/etc/yum.repo.d/adoptopenjdk.repo',
      }
    }
    default : {}
  }
}
