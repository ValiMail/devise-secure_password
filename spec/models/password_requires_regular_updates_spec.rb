require 'spec_helper'

RSpec.describe Devise::Models::PasswordRequiresRegularUpdates, type: :model do
  let(:password) { 'Bubb1234@#$!' }
  let(:user) do
    Isolated::UserRegularUpdates.new(
      email: 'barney@rubble.com',
      password: password,
      password_confirmation: password
    )
  end

  describe 'config' do
    subject { Isolated::UserRegularUpdates }

    it { is_expected.to respond_to(:password_maximum_age) }

    context 'when password_frequent_change_prevention module is not enabled' do
      it 'raises a ConfigurationError' do
        expect do
          Isolated::UserRegularUpdatesBad.new
        end.to raise_error(Devise::Models::PasswordRequiresRegularUpdates::ConfigurationError)
      end
    end

    context 'when config.password_maximum_age is invalid' do
      it 'raises a ConfigurationError' do
        expect do
          Isolated::UserRegularUpdatesBadConfig.new
        end.to raise_error(Devise::Models::PasswordRequiresRegularUpdates::ConfigurationError, /invalid type/)
      end
    end
  end

  describe '#password_expired?' do
    subject { user }

    it { is_expected.to respond_to(:password_expired?) }

    context 'when password has expired' do
      before do
        user.save
        # reset its previous_password record to one day past maximum
        last_password = user.previous_passwords.first
        last_password.created_at = Time.zone.now - Isolated::UserRegularUpdates.password_maximum_age
        last_password.save
      end

      it 'returns true' do
        expect(user.password_expired?).to be true
      end
    end

    context 'when password has not expired' do
      before { user.save }

      it 'returns false' do
        expect(user.password_expired?).to be false
      end
    end
  end
end
