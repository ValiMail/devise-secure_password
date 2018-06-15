# lib/support/string/grammar.rb
#
module Devise
  module SecurePassword
    module Grammar
      # distance_in_words without determiner words: about, almost, over, etc.
      def precise_distance_of_time_in_words(from_time, to_time = 0, options = {})
        precise_options = { scope: :'secure_password.datetime.precise_distance_in_words' }
        distance_of_time_in_words(from_time, to_time, options.merge!(precise_options))
      end
    end
  end
end
