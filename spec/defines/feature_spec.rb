require 'spec_helper'

describe 'windows_common::configuration::feature' do

  context "on Windows platforms" do
    let(:facts) {{ :osfamily => 'windows' }}

    context "with existing feature and default parameters" do
      let(:title) { 'Hyper-V' }

      it {
        should contain_exec('add-windows-feature-Hyper-V').with({
          'command'  => 'Add-WindowsFeature -Name Hyper-V',
          'provider' => 'powershell',
        })
      }
    end

    context "with existing feature and ensure => absent" do
      let(:title) { 'Hyper-V' }
      let(:params) {{ :ensure => 'absent'  }}

      it {
        should contain_exec('remove-windows-feature-Hyper-V').with({
          'command'  => 'Remove-WindowsFeature -Name Hyper-V',
          'provider' => 'powershell',
        })
      }
    end

    context "with non existing feature" do
      let(:title) { 'Foo-Windows-Feature' }

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error)
      end
    end

    context "with ensure => not present nor absent" do
      let(:title) { 'Hyper-V' }
      let(:params) {{ :ensure => 'ok'}}

      it 'should fail' do
        expect { should }.to raise_error(Puppet::Error)
      end
    end
  end

  context "on an unsupported OS" do
    let (:facts) {{ :osfamily => 'linux' }}

    it 'should fail' do
      expect { should }.to raise_error(Puppet::Error)
    end
  end
end
