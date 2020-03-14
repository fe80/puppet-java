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
    'Debian': {
      ensure_packages('software-properties-common')
      apt::source { 'adoptopenjdk':
        ensure   => $java::ensure,
        location => 'https://adoptopenjdk.jfrog.io/adoptopenjdk/deb',
        repos    => 'main',
        release  => $facts['lsbdistcodename'],
        key      => {
          source => 'https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public',
          id     => '8ED17AF5D7E675EB3EE3BCE98AC3B29174885C03',
        }
      }
    }
    default : {}
  }
}
