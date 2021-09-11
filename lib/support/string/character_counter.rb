# lib/support/character_counter.rb
#
module Support
  module String
    class CharacterCounter
      attr_reader :count_hash

      def initialize
        @count_hash = {
          length: { count: 0 },
          uppercase: characters_to_dictionary(('A'..'Z').to_a),
          lowercase: characters_to_dictionary(('a'..'z').to_a),
          number: characters_to_dictionary(('0'..'9').to_a),
          special: characters_to_dictionary(%w(! @ # $ % ^ & * ( ) _ + - = [ ] { } | ' " / \ ^ . , ` < > : ; ? ~)),
          unknown: {}
        }
      end

      def count(string)
        raise ArgumentError, "Invalid value for string: #{string}" if string.nil?

        string.chars.each { |c| tally_character(c) }
        @count_hash[:length][:count] = string.length

        @count_hash
      end

      private

      def characters_to_dictionary(array)
        dictionary = {}
        array.each { |c| dictionary.store(c, 0) }

        dictionary
      end

      def tally_character(character)
        %i(uppercase lowercase number special unknown).each do |type|
          if @count_hash[type].key?(character)
            @count_hash[type][character] += 1
            return @count_hash[type][character]
          end
        end

        # must be new unknown char
        @count_hash[:unknown][character] = 1
        @count_hash[:unknown][character]
      end

      def character_in_dictionary?(character, dictionary)
        dictionary.key?(character)
      end
    end
  end
end
