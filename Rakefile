#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :rurema! do
  $LOAD_PATH.unshift __dir__ + '/lib'

  require 'ruremai'
  require 'irb'

  ARGV.shift # XXX

  Ruremai.verbose = true
  puts %(Default locales: #{Ruremai.default_locales})

  IRB.start __FILE__
end

task default: :spec
