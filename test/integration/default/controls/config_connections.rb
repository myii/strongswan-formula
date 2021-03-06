control 'Strongswan connections configuration' do
  title 'should match desired lines'

  describe directory('/etc/ipsec.conf.d') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end

  # we verify presence of all connection files
  ['conn_a', 'conn_b'].each do |conn|
    describe file("/etc/ipsec.conf.d/#{conn}.conf") do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      its('mode') { should cmp '0644' }
      its('content') { should include "conn #{conn}" }
    end
  end

  # but we only verify the full content of one
  describe file('/etc/ipsec.conf.d/conn_a.conf') do
    its('content') { should include '    authby=secret' }
    its('content') { should include '    auto=add' }
    its('content') { should include '    esp=3des-sha1' }
    its('content') { should include '    ike=3des-sha1-modp1024' }
    its('content') { should include '    left=10.10.1.1' }
    its('content') { should include '    leftsubnet=10.10.1.0/32' }
    its('content') { should include '    right=10.20.1.1' }
    its('content') { should include '    rightsubnet=10.20.1.0/32' }
  end
end
