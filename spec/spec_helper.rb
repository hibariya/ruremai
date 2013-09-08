# coding: utf-8

$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')

require 'ruremai'
require 'tapp'

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
