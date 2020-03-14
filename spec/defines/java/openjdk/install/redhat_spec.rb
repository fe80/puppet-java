require 'spec_helper'
describe 'java::openjdk::install::redhat' do
  on_supported_os.each do |os, facts|
    next if facts[:osfamily] != 'RedHat'

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

        it { is_expected.to compile }

        it do
          is_expected.to contain_package('java-1.8.0-openjdk').with(
            ensure: status,
            tag: 'openjdk',
          )
        end
      end
    end

    context "With openjdk 11 on #{os}" do
      let(:facts) { facts }
      let(:title) { 'openjdk-8' }
      let(:params) do
        {
          version: 11,
          ensure: 'present',
        }
      end

      if facts[:operatingsystemmajrelease].to_i < 7
        it { is_expected.to compile.and_raise_error(%r{Unsupported version}) }
      else
        it { is_expected.to compile }
      end

      it do
        is_expected.to contain_package('java-11-openjdk').with(
          ensure: 'present',
          tag: 'openjdk',
        )
      end
    end
  end
end
