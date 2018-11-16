require 'benchmark'
require 'spec_helper'

bcrypt_cost = 11 # devise default is 1 for tests, 11 for production
max_count = Isolated::UserFrequentReuse.password_previously_used_count
password = 'Bubb1234@#$!'

user = Isolated::UserFrequentReuse.new(
  email: 'barney@rubble.com',
  password: password,
  password_confirmation: password
)

puts 'Setting up benchmark (validate_password_frequent_reuse)...'
puts "-> creating User with #{max_count} previous passwords\n\n"

# save user and populate previous_passwords with max_count passwords
Devise.stretches = bcrypt_cost
passwords = (0..max_count - 1).map { |c| user.password + c.to_s }
passwords[0..max_count - 1].each do |p|
  user.password = user.password_confirmation = p
  user.save!
end

puts 'Running benchmark (validate_password_frequent_reuse)...'
puts "-> validating User new password against #{max_count} previous passwords\n\n"

# benchmark the password_disallows_frequent_reuse::previous_password? method
Benchmark.bmbm(20) do |bm|
  # make sure we check the very first password used, which will appear at the
  # end of the results, so that we cycle through all salts (previous_password?
  # will encrypt the new clear password with each previous salt in DESC order).
  bm.report('validate_password_frequent_reuse') do
    oldest_password = passwords.first
    user.password = user.password_confirmation = oldest_password
    user.valid?
  end
end

puts "Completed benchmark (validate_password_frequent_reuse)\n\n"
