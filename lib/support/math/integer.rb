# lib/support/math/integer.rb
#
module Support
  module Math
    class Integer
      N_BYTES = [42].pack('i').size
      N_BITS = N_BYTES * 8
      MAX = 2**(N_BITS - 2) - 1
      MIN = -MAX - 1
    end
  end
end
