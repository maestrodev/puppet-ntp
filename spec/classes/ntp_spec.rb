require "#{File.join(File.dirname(__FILE__),'..','spec_helper')}"

describe 'ntp' do

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

  context "when not passing servers" do
    it { should_not contain_augeas('ntp') }
  end

  context "when passing servers" do
    let(:params) { {:servers => ['server1', 'server2']} }

    it { should contain_augeas('ntp') }

    it 'should have the augeas changes' do
      expected = 'rm server
  set server[last()+1] server1
  set server[last()+1] server2'
      content = catalogue.resource('augeas', 'ntp').send(:parameters)[:changes]
      content.strip.should == expected
    end
  end

end
