require 'spec_helper'
require 'support/string/locale_tools'

RSpec.describe Devise::Models::PasswordFrequentChangePrevention, type: :model do
  include ActionView::Helpers::DateHelper

  let(:password) { 'Bubb1234@#$!' }
  let(:user) do
    Isolated::UserFrequentChange.new(
      email:                 'barney@rubble.com',
      password:              password,
      password_confirmation: password
    )
  end

  describe 'config' do
    subject { Isolated::UserFrequentChange }
    it { is_expected.to respond_to(:password_minimum_age) }

    context 'when password_frequent_reuse_prevention module is not enabled' do
      it 'raises a ConfigurationError' do
        expect { Isolated::UserFrequentChangeBad.new }.to raise_error(Devise::Models::PasswordFrequentChangePrevention::ConfigurationError)
      end
    end

    context 'when config.password_minimum_age is invalid' do
      it 'raises a ConfigurationError' do
        expect { Isolated::UserFrequentChangeBadConfig.new }.to raise_error(Devise::Models::PasswordFrequentChangePrevention::ConfigurationError)
      end
    end
  end

  describe 'validations' do
    subject { user }

    context 'when password has been changed recently' do
      before do
        user.save(validate: false)
        user.password = user.password + 'Z'
        user.save
      end
      it { is_expected.not_to be_valid }

      it 'has the correct error message' do
        error_string = LocaleTools.replace_macros(
          I18n.translate('dppe.password_frequent_change_prevention.errors.messages.password_is_recent'),
          timeframe: distance_of_time_in_words(user.class.password_minimum_age)
        )
        expect(user.errors.full_messages).to include error_string
      end
    end

    context 'when password has not been changed recently' do
      before do
        user.save
        # reset its previous_password record to one day before
        last_password = user.previous_passwords.unscoped.last
        last_password.created_at = Time.zone.now - Isolated::UserFrequentChange.password_minimum_age
        last_password.save
        # bypass frequent_reuse validator by changing password
        user.password = user.password_confirmation = user.password + 'Z'
      end
      it { is_expected.to be_valid }
    end
  end
end
