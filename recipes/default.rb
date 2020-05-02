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
