
include_recipe 'apt'
apt_update 'update_sources' do
  action :update
end

apt_update "update" do
  action :update
end

package "nginx"
service "nginx" do
  action [:enable, :start]
end

include_recipe 'nodejs'

nodejs_npm 'pm2'

