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
                '/usr/lib/jvm/jre-11-openjdk/bin/%s' % [bin]
              )
            end
            it { is_expected.to contain_alternatives(bin) }
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
                '/usr/lib/jvm/java-%s-openjdk-amd64/bin/%s' % [version, bin]
              )
              is_expected.to contain_alternatives(bin)
            end
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

          # Defines
          it { is_expected.to contain_apt__source('java-oracle') }

          # Package
          it { is_expected.to contain_package('oracle-java8-jdk') }

          # Alternatives
          ['java', 'jar', 'javac'].each do |bin|
            it do
              is_expected.to contain_alternative_entry(
                '/opt/oracle-java8/jdk/bin/%s' % [bin]
              )
            end
            it { is_expected.to contain_alternatives(bin) }
          end
        end
      end
    end
  end
end
