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
          [ 'java', 'jar', 'javac' ].each do |bin|
            it do
              is_expected.to contain_alternative_entry(
                "/usr/lib/jvm/jre-11-openjdk/bin/#{bin}"
              )
            end
            it { is_expected.to contain_alternatives(bin) }
          end
        else

          # Package
          if facts[:operatingsystem] == 'Debian'
            version = 7
          else
            if facts[:operatingsystemmajrelease].to_f >= 18.04
              version = 11
            else
              version = 8
            end
          end

          # Define
          it do
            is_expected.to contain_java__openjdk__install__debian("openjdk-#{version}")
          end

          # Package
          it { is_expected.to contain_package("openjdk-#{version}-jdk") }

          # Alternatives
          [ 'java', 'jar', 'javac', 'jarsigner', 'javap', 'javadoc' ].each do |bin|
            it do
              is_expected.to contain_alternative_entry(
                "/usr/lib/jvm/java-#{version}-openjdk-amd64/bin/#{bin}"
              )
            end
            it { is_expected.to contain_alternatives(bin) }
          end
        end
      end

      context 'with oracle provider' do
        let(:params) {{
          provider: 'oracle',
          versions: [ 8 ],
        }}

        if facts[:osfamily] == 'RedHat'
          it { should compile.and_raise_error(/Unsupported/) }
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
          [ 'java', 'jar', 'javac' ].each do |bin|
            it do
              is_expected.to contain_alternative_entry(
                "/opt/oracle-java8/jdk/bin/#{bin}"
              )
            end
            it { is_expected.to contain_alternatives(bin) }
          end
        end
      end
    end
  end
end
