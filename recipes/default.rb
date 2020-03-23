
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

template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  variables proxy_port: node['nginx']['proxy_port']
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/default' do
  action :delete
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies :restart, 'service[nginx]'
end
