class UserFrequentChangeBad < User
  #
  # Should trigger a ConfigurationError:
  #   - :password_frequent_change_prevention enabled
  #   - :password_frequent_reuse_prevention missing
  #
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :password_frequent_change_prevention
end
