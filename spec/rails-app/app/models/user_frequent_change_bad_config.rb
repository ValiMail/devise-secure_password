class UserFrequentChangeBadConfig < User
  #
  # Should trigger a ConfigurationError:
  #   - password_minimum_age is invalid type
  #
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :password_frequent_change_prevention

  class << self
    def password_minimum_age
      10
    end
  end

end
