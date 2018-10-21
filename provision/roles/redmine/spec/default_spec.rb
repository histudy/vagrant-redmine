require 'spec_helper'

describe user(property['redmine_user']) do
  it { should exist }
end

property['redmine_dependency_packages'].each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end

describe file(property['redmine_home']) do
  it { should exist }
  it { should be_directory }
end

property['redmine_themes'].each do |theme|
  describe file(property['redmine_home'] + '/public/themes/' + theme['name']) do
    it { should exist }
    it { should be_directory }
  end
end

describe service('redmine') do
  it { should be_enabled }
  it { should be_running }
end
