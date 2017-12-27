# :have_constant matcher
#
# Test whether a class or instance has a specified constant.
#
# syntax:
#   it { is_expected.to have_constant(:MAX_LENGTH) }
#
RSpec::Matchers.define :have_constant do |const|
  match do |object|
    (object.is_a?(Class) ? object : object.class).const_defined?(const)
  end
end
