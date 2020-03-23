
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


include_recipe 'beats_cookbook::default'

template 'etc/metricbeat/metricbeat.yml' do
  source 'metricbeat.yml.erb'
  mode '777'
  owner 'root'
  group 'root'
end

execute 'fix_template' do
  command 'sudo chmod go-w /etc/metricbeat/metricbeat.yml'
end


execute 'enable_module_system' do
  command 'sudo metricbeat modules enable system'
end

execute 'enable_module_nginx_metric' do
  command 'sudo metricbeat modules enable nginx'
end

#execute 'setup_dasboards' do
#  command 'sudo metricbeat setup'
#end

template 'etc/filebeat/filebeat.yml' do
  source 'filebeat.yml.erb'
  mode '777'
  owner 'root'
  group 'root'
end

execute 'fix_template' do
  command 'sudo chmod go-w /etc/filebeat/filebeat.yml'
end

execute 'enable_module_syslogs' do
  command 'sudo filebeat modules enable system'
end


#execute 'setup_dasboards' do
#  command 'sudo filebeat setup'
#end

service 'metricbeat' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

service 'filebeat' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

