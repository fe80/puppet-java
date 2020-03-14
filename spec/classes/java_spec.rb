require 'spec_helper'

describe 'java' do
  on_supported_os(facterversion: '3.6').each do |os, facts|
    context "with default for all parameters on #{os}" do
      let(:pre_condition) do
        "Exec { path => '/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/sbin:/usr/local/bin' }"
      end

      let(:facts) do
        facts
      end

      it do
        is_expected.to compile.with_all_deps
      end

      context 'with defaults for all parameters' do
        # Classes
        it { is_expected.to contain_class('java::params') }
        it { is_expected.to contain_class('java::openjdk') }
        it { is_expected.to contain_class('java::openjdk::params') }
        it { is_expected.to contain_class('java::openjdk::alternatives') }
        it { is_expected.to contain_class('java::openjdk::install') }
        it { is_expected.to contain_class('java::profile') }
        it { is_expected.to contain_class('java::default') }

        # Files
        it do
          is_expected.to contain_file('/etc/profile.d/java.sh').with(
            ensure: 'present',
          )
        end

        if facts[:osfamily] == 'RedHat'
          # Define
          it do
            is_expected.to contain_java__openjdk__install__redhat('openjdk-11')
          end

          # Package
          it { is_expected.to contain_package('java-11-openjdk') }

          # Alternatives
          ['java', 'jar', 'javac'].each do |bin|
            it do
              is_expected.to contain_alternative_entry(
                '/usr/lib/jvm/jre-11-openjdk/bin/%s' % [bin],
              )
            end
            it { is_expected.to contain_alternatives(bin) }
          end

          # File
          it { is_expected.to contain_file('/etc/default/java-11') }
          it do
            is_expected.to contain_file('/etc/default/java').with(
              ensure: 'link',
              target: '/etc/default/java-11',
            )
          end
        else

          # Package
          version = if facts[:operatingsystem] == 'Debian'
                      7
                    elsif facts[:operatingsystemmajrelease].to_f >= 18.04
                      version = 11
                    else
                      version = 8
                    end

          # Define
          it do
            is_expected.to contain_java__openjdk__install__debian('openjdk-%s' % version)
          end

          # Package
          it { is_expected.to contain_package('openjdk-%s-jdk' % [version]) }

          # Alternatives
          ['java', 'jar', 'javac', 'jarsigner', 'javap', 'javadoc'].each do |bin|
            it do
              is_expected.to contain_alternative_entry(
                '/usr/lib/jvm/java-%s-openjdk-amd64/bin/%s' % [version, bin],
              )
              is_expected.to contain_alternatives(bin)
            end
          end

          # File
          it { is_expected.to contain_file('/etc/default/java-' + version.to_s) }
          it do
            is_expected.to contain_file('/etc/default/java').with(
              ensure: 'link',
              target: '/etc/default/java-' + version.to_s,
            )
          end
        end
      end

      context 'with oracle provider' do
        let(:params) do
          {
            'provider' => 'oracle',
            'versions' => [8],
            'mirror' => 'https://mymirror.com/oracle/apt',
          }
        end

        if facts[:osfamily] == 'RedHat'
          it { is_expected.to compile.and_raise_error(%r{Unsupported}) }
        else
          # Classes
          it { is_expected.to contain_class('java::oracle') }
          it { is_expected.to contain_class('java::oracle::repo') }
          it { is_expected.to contain_class('java::oracle::install') }
          it { is_expected.to contain_class('java::oracle::alternatives') }
          it { is_expected.to contain_class('java::profile') }
          it { is_expected.to contain_class('java::default') }

          # Defines
          it { is_expected.to contain_apt__source('java-oracle') }

          # Package
          it { is_expected.to contain_package('oracle-java8-jdk') }

          # Alternatives
          ['java', 'jar', 'javac'].each do |bin|
            it do
              is_expected.to contain_alternative_entry(
                '/opt/oracle-java8/jdk/bin/%s' % [bin],
              )
            end
            it { is_expected.to contain_alternatives(bin) }
          end

          # File
          it { is_expected.to contain_file('/etc/default/java-8') }
          it do
            is_expected.to contain_file('/etc/default/java').with(
              ensure: 'link',
              target: '/etc/default/java-8',
            )
          end
        end
      end

      context 'with adoptopenjdk provider' do
        let(:params) do
          {
            'provider' => 'adoptopenjdk',
          }
        end

        # Classes
        it { is_expected.to contain_class('java::adoptopenjdk') }
        it { is_expected.to contain_class('java::adoptopenjdk::repo') }
        it { is_expected.to contain_class('java::adoptopenjdk::install') }
        it { is_expected.to contain_class('java::adoptopenjdk::alternatives') }
        it { is_expected.to contain_class('java::profile') }
        it { is_expected.to contain_class('java::default') }

        if facts[:osfamily] == 'RedHat'
          it do
            is_expected.to contain_yumrepo('adoptopenjdk').with(
              gpgkey: 'https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public',
              target: '/etc/yum.repo.d/adoptopenjdk.repo',
            )
          end
        end

        if facts[:osfamily] == 'Debian'
          facts[:os] ||= {}
          it { is_expected.to contain_package('software-properties-common') }
          it do
            is_expected.to contain_apt__source('adoptopenjdk').with(
              location: 'https://adoptopenjdk.jfrog.io/adoptopenjdk/deb',
              release: facts[:lsbdistcodename],
              repos: 'main',
              key: {
                'source' => 'https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public',
                'id' => '8ED17AF5D7E675EB3EE3BCE98AC3B29174885C03',
              }
            )
          end
        end

        # Package
        it { is_expected.to contain_package('adoptopenjdk-13-openj9') }

        # Alternatives
        ['java', 'jar', 'javac'].each do |bin|
          it do
            is_expected.to contain_alternative_entry(
              '/usr/lib/jvm/adoptopenjdk-13-openj9/bin/%s' % [bin],
            )
          end
          it { is_expected.to contain_alternatives(bin) }
        end

        # File
        it { is_expected.to contain_file('/etc/default/java-13') }
        it do
          is_expected.to contain_file('/etc/default/java').with(
            ensure: 'link',
            target: '/etc/default/java-13',
          )
        end
      end
    end
  end
end
