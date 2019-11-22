require 'spec_helper'

describe 'java::openjdk::install::debian' do
  let(:title) { 'my_define' }

  on_supported_os(facterversion: '3.6').each do |os, facts|
    context "Openjdk 8 on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) { { 'version' => 8 } }

      if facts[:osfamily] == 'Debian'
        if facts[:operatingsystemmajrelease] == '8'
          it { should compile.and_raise_error(/Unsupported/) }
        else
          it {
            is_expected.to contain_package('openjdk-8-jdk')
          }
        end
      else
        it { should compile.and_raise_error(/Unsupported/) }
      end

    end
  end
end
