# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

desc 'Build Docker image'
task docker_build: [:build] do |t|
  `docker build -t actiondoc-#{ActionDoc::VERSION} .`
end

task default: :test
