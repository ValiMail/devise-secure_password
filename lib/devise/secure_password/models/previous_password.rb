module Devise
  module Models
    class PreviousPassword < ::ActiveRecord::Base
      self.table_name = 'previous_passwords'
      belongs_to :user
      default_scope -> { order(created_at: :desc) }
      validates :user_id, presence: true
      validates :salt, presence: true
      validates :encrypted_password, presence: true

      def fresh?(minimum_age_duration, now = ::Time.zone.now)
        now <= (created_at + minimum_age_duration)
      end

      def stale?(maximum_age_duration, now = ::Time.zone.now)
        now > (created_at + maximum_age_duration)
      end
    end
  end
end
