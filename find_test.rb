require 'find'

total_size = 0

Find.find('.') do |name|
  p File.file?(name)
end