# coding: utf-8

$LOAD_PATH.unshift File.dirname(__dir__) + '/lib'

require 'ruremai'
require 'tapp'

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
