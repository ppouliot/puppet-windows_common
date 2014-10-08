require 'spec_helper'

describe 'windows_common::client::mapped_drive' do

  context "on Windows platforms" do
    let(:facts) {{ :osfamily => 'windows' }}

    context "with valid information" do
      let(:title) { 'Z:' }
      let(:params) {{ :ensure => 'present', :server => 'host.com', :share => 'folder'}}
      it {
        should contain_exec('mount-Z:').with( {'command'  => 'net.exe use Z: \\\\host.com\\folder /persist:yes'} )
      }
    end
  end
end
