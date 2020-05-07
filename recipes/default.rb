#
# Cookbook:: elasticsearch
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
include_recipe 'apt'

apt_update 'update_sources' do
  action :update
end

apt_update "update" do
  action :update
end

package "openjdk-8-jdk"

package "apt-transport-https"

execute "add key" do
  command 'wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -'
end

execute "add repository" do
  command 'sudo add-apt-repository "deb https://artifacts.elastic.co/packages/7.x/apt stable main"'
end

apt_update "update" do
  action :update
end

package "elasticsearch" do
  action :install
end

template '/etc/elasticsearch/elasticsearch.yml' do
  source 'elasticsearch.yml.erb'
  mode '666'
  owner 'root'
  group 'root'
end

execute 'fix_template' do
  command 'sudo chmod go-w /etc/elasticsearch/elasticsearch.yml'
end

service 'elasticsearch' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end


#==============================HEARTBEAT=======================================
# execute "add key" do
#   command 'wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -'
# end

execute "add repository" do
  command 'sudo add-apt-repository "deb https://artifacts.elastic.co/packages/7.x/apt stable main"'
end

apt_update "update" do
  action :update
end

package "heartbeat-elastic" do
  action :install
end

# execute 'heartbeat setup' do
#   command 'sudo heartbeat setup'
# end

template 'etc/heartbeat/heartbeat.yml' do
  source 'heartbeat.yml.erb'
  mode '666'
  owner 'root'
  group 'root'
end

template 'etc/heartbeat/monitors.d/heartbeatdemo.yml' do
  source 'heartbeatdemo.yml.erb'
  mode '666'
  owner 'root'
  group 'root'
end

execute 'fix_template' do
  command 'sudo chmod go-w /etc/heartbeat/heartbeat.yml'
end

execute 'fix_template_demo' do
  command 'sudo chmod go-w /etc/heartbeat/monitors.d/heartbeatdemo.yml'
end

service 'heartbeat-elastic' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end
