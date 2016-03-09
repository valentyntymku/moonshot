if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start do
    add_filter '/spec/'
  end
end

# RSpec brings this in ad-hoc, but if it comes in after fakefs we get
# superclass mismatch errors.
require 'pp'
require 'moonshot'
require 'fakefs/spec_helpers'

shared_examples 'with a working moonshot application' do
  include FakeFS::SpecHelpers

  before(:all) do
    # Force aws-sdk to load metadata before FakeFS takes over.
    Aws::CloudFormation::Client.new
  end

  before(:each) do
    FileUtils.mkdir_p '/cloud_formation/parameters'
    FakeFS::FileSystem.clone(File.join(File.dirname(__FILE__), 'fs_fixtures'), '/')
  end
end
