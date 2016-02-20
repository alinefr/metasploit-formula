require 'serverspec'

set :backend, :exec

describe service('metasploit') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/opt/metasploit') do
  it { should be_directory }
end
