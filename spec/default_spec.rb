require 'spec_helper'

property['ruby_packages'].each do |pkg|
  describe package(pkg) do
    it { should be_installed }
  end
end
