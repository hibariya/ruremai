# coding: utf-8

require_relative '../lib/ruremai'

RSpec.configure do |config|
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
