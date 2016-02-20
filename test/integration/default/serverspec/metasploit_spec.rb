require 'serverspec'

set :backend, :exec

describe file('/opt/metasploit') do
  it { should be_directory }
end
