require 'spec_helper'
describe 'java::openjdk::install::debian' do
  on_supported_os.each do |os, facts|
    next if facts[:osfamily] != 'Debian'

    ['present', 'absent'].each do |status|
      context "With #{status} openjdk 8 on #{os}" do
        let(:facts) { facts }
        let(:title) { 'openjdk-8' }
        let(:params) do
          {
            version: 8,
            ensure: status,
          }
        end

        if facts[:operatingsystemmajrelease].to_s =~ %r{^(8|14.04)$}
          it { is_expected.to compile.and_raise_error(%r{Unsupported version}) }
          next
        else
          it { is_expected.to compile }
        end

        it do
          is_expected.to contain_package('openjdk-8-jdk').with(
            ensure: status,
            tag: 'openjdk',
          )
        end
      end
    end
  end
end
