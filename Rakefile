require "bundler/gem_tasks"

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' 
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end
