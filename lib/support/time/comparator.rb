# lib/support/time/comparator.rb
#
module Support
  module Time
    class Comparator
      require 'date'

      # Determine if a time has exceeded a delay
      #
      # The delay is calculated as the period between the time plus the
      # time_delay.
      #
      # @param time [Time] The time to evaluate
      # @param time_delay [Time] The amount of time to delay
      # @param time_now [Time] Current time
      # @return [Boolean] Whether or not the delay has expired
      #
      def self.time_delay_expired?(time, time_delay, time_now = ::Time.zone.now)
        time_now > time + time_delay
      end

      # Determine if a time falls within a range
      #
      # The range is calculated from the period between the lower and upper
      # bounds.
      #
      # @param time [Time] The time to evaluate
      # @param lower_bound [Time] The lower bound
      # @param upper_bound [Time] The upper bound
      # @return [Boolean] Whether or not time falls within range
      #
      def self.time_in_range?(time, lower_bound, upper_bound)
        time >= lower_bound && time <= upper_bound
      end
    end
  end
end
