# lib/support/locale_tools.rb
#
# A class that implements utility methods for accessing and manipulating locale
# strings.
#
module Support
  module String
    class LocaleTools
      # Returns a string with macro patterns replaced by values.
      #
      # @example
      #   my_string: "password contains %{count} invalid %{subject}"
      #     LocaleTools.replace_macros(my_string,
      #                                 count: '1',
      #                                 subject: 'uppercase characters'
      #     )
      #   result: "password contains 1 invalid uppercase characters"
      #
      # @param string [String] a string to perform a replace on
      # @param values [Hash] a hash containing keys that represent macro names
      #   and their replacement values
      # @return [String] string with macros replaced by their named values
      # @raise [ArgumentError] if values for string and/or hash are nil
      #
      def self.replace_macros(string, values = {})
        raise ArgumentError, "Invalid value for string: #{string}" if string.nil?
        raise ArgumentError, "Invalid value for values: #{values}" if values.nil?

        return string if values.empty?

        # create a hash with our macro formatters as keys
        macro_values_hash = {}
        values.each_key { |key| macro_values_hash.store("%{#{key}}", values[key]) }

        # replace string macros
        string.gsub(/(%{[\w\-]+})/, macro_values_hash)
      end
    end
  end
end
