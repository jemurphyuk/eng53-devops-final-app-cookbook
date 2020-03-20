# InSpec test for recipe app_cookbook::default


# This is an example test, replace it with your own test.
describe port(80) do
  it { should be_listening }
end

describe service "nginx" do
  it { should be_running }
  it { should be_enabled }
end

describe http('http://localhost', enable_remote_worker: true) do
  its('status') { should cmp 502 }
end

describe package ('nodejs') do
  it { should be_installed }
  its('version') { should cmp > '8.11.2*' }
end

describe npm ('pm2') do
  it { should be_installed }
end
