require 'spec_helper'

describe 'ntp' do
  let(:params) { {:ntpServerList => []} }

  context "when running on CentOS" do
    let(:facts) { {:operatingsystem => 'CentOS'} }

    it { should contain_package('ntp').with_name('ntp') }
    it { should contain_service('ntpd').with_name('ntpd') }
  end

  context "when running on Solaris" do
    let(:facts) { {:operatingsystem => 'Solaris'} }

    it { should contain_package('ntp').with_name('SUNWntpu') }
    it { should contain_service('ntpd').with_name('ntp') }
  end
end
