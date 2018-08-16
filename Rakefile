require 'rake/testtask'
require "bundler/gem_tasks"
require 'rake'
require 'find'

desc 'Say hello'
task :hello do
  puts "Hello there. This is the 'hello' task."
end

desc 'Run tests'
task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end


desc 'Display inventory of all files via Rake FileList'
task :inventory_rake do
  files = Rake::FileList.new('**/*') do |fl|
    fl.exclude do |f|
      !File.file?(f)
    end
  end
  puts files
end

desc 'Display inventory of all files with Find#find'
task :inventory_find do
  Find.find('.') do |name|
    puts name if File.file?(name) unless name.start_with?('./.')
  end
end

