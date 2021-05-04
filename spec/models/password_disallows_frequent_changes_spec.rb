require 'spec_helper'

RSpec.describe Devise::Models::PasswordDisallowsFrequentChanges, type: :model do
  include ActionView::Helpers::DateHelper
  include Devise::SecurePassword::Grammar

  let(:password) { 'Bubb1234@#$!' }
  let(:user) do
    Isolated::UserFrequentChanges.new(
      email: 'barney@rubble.com',
      password: password,
      password_confirmation: password
    )
  end

  describe 'config' do
    subject { Isolated::UserFrequentChanges }

    it { is_expected.to respond_to(:password_minimum_age) }

    context 'when password_frequent_reuse_prevention module is not enabled' do
      it 'raises a ConfigurationError' do
        expect { Isolated::UserFrequentChangesBad.new }.to raise_error(Devise::Models::PasswordDisallowsFrequentChanges::ConfigurationError)
      end
    end

    context 'when config.password_minimum_age is invalid' do
      it 'raises a ConfigurationError' do
        expect { Isolated::UserFrequentChangesBadConfig.new }.to raise_error(Devise::Models::PasswordDisallowsFrequentChanges::ConfigurationError)
      end
    end
  end

  describe 'validations' do
    subject { user }

    before do
      Devise.setup { |config| config.password_minimum_age = 1.day }
    end

    after do
      Devise.setup { |config| config.password_minimum_age = 0.days }
    end

    context 'when password has been changed recently' do
      before do
        user.save(validate: false)
        user.password = "#{user.password}Z"
        user.save
      end

      it { is_expected.not_to be_valid }

      it 'has the correct error message' do
        error_string = I18n.t(
          'secure_password.password_disallows_frequent_changes.errors.messages.password_is_recent',
          timeframe: precise_distance_of_time_in_words(user.class.password_minimum_age)
        )
        expect(user.errors.full_messages).to include error_string
      end
    end

    context 'when password has not been changed recently' do
      before do
        user.save
        # reset its previous_password record to one day before
        last_password = user.previous_passwords.first
        last_password.created_at = Time.zone.now - Isolated::UserFrequentChanges.password_minimum_age
        last_password.save
        # bypass frequent_reuse validator by changing password
        user.password = user.password_confirmation = "#{user.password}Z"
      end

      it { is_expected.to be_valid }
    end
  end

  describe '#password_recent?' do
    subject { user }

    before do
      Devise.setup { |config| config.password_minimum_age = 1.day }
    end

    after do
      Devise.setup { |config| config.password_minimum_age = 0.days }
    end

    it { is_expected.to respond_to(:password_recent?) }

    context 'when password is not recent' do
      before do
        user.save
        # reset its previous_password record one day past minimum
        last_password = user.previous_passwords.first
        last_password.created_at = Time.zone.now - Isolated::UserFrequentChanges.password_minimum_age
        last_password.save
      end

      it 'returns false' do
        expect(user.password_recent?).to be false
      end
    end

    context 'when password is recent' do
      before { user.save }

      it 'returns true' do
        expect(user.password_recent?).to be true
      end
    end
  end
end
