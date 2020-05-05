#
# Cookbook:: elasticsearch
# Spec:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'elasticsearch::default' do
  context 'When all attributes are default, on Ubuntu 18.04' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'ubuntu', '16.04'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    it 'enables the elasticsearch service' do
      expect(chef_run).to enable_service 'elasticsearch'
    end

    it 'should update source list' do
     expect(chef_run).to update_apt_update('update_sources')
    end

    it 'should create an elasticsearch template in /etc/elasticsearch/elasticsearch.yml' do
      expect(chef_run).to create_template('/etc/elasticsearch/elasticsearch.yml')
    end
  end
end
