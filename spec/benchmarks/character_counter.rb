require 'benchmark'
require 'support/string/character_counter'
require 'spec_helper'

character_counter = ::Support::String::CharacterCounter.new
categories = character_counter.count_hash.values.map(&:keys)
dictionary = categories.flatten

puts 'Setting up benchmark (character_counter)...'
puts '-> creating a long string with characters from:'
categories.each_with_index { |c, i| puts "[#{i}]: #{c.join(', ')}" }
puts("\n")

# create a long string of mixed chars
length = 256
string = (dictionary * (length / dictionary.length.to_f).ceil).shuffle.join.slice(0, length)

puts 'Running benchmark (character_counter)...'
puts "-> updating count_hash from string with #{length} characters\n\n"
total_seen = 0

# benchmark the count method, the summarized count (reduce) will add minimal overhead
Benchmark.bmbm(20) do |bm|
  bm.report('character_counter.count') do
    total_seen = ::Support::String::CharacterCounter.new.count(string).values.map(&:values).flatten.reduce(0, :+)
  end
end

puts 'Completed benchmark (character_counter)...'
puts "-> counted #{total_seen} characters\n\n"
