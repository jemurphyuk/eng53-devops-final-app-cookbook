#
# Cookbook:: app_cookbook
# Spec:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'app_cookbook::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '18.04'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'should apt_update' do
      expect(chef_run).to update_apt_update 'update_sources'
    end

    it 'should install nginx' do
      expect(chef_run).to install_package "nginx"
    end

    it 'enables nginx' do
      expect(chef_run).to enable_service 'nginx'
    end

    it 'start nginx' do
      expect(chef_run).to start_service 'nginx'
    end

    it "should create proxy.conf" do
      expect(chef_run).to create_template("/etc/nginx/sites-available/proxy.conf").with_variables(proxy_port: 3000)
    end

    it "should delete existing link between default" do
      expect(chef_run).to delete_link('/etc/nginx/sites-enabled/default')
    end

    it "assert a link was created" do
      expect(chef_run).to create_link('/etc/nginx/sites-enabled/proxy.conf').with(to: '/etc/nginx/sites-available/proxy.conf')
    end

    it "installed nodejs from recipe" do
      expect(chef_run).to include_recipe("nodejs")
    end

    it "install pm2 via npm" do
      expect(chef_run).to install_nodejs_npm('pm2')
    end
  end
end
