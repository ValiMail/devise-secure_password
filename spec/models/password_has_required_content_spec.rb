require 'spec_helper'

RSpec.describe Devise::Models::PasswordHasRequiredContent, type: :model do
  before do
    Devise.setup do |config|
      config.password_length = (8..128)
      config.password_required_uppercase_count = 1
      config.password_required_lowercase_count = 1
      config.password_required_number_count = 1
      config.password_required_special_character_count = 1
    end
  end

  after do
    Devise.setup do |config|
      config.password_length = (8..128)
      config.password_required_uppercase_count = 0
      config.password_required_lowercase_count = 0
      config.password_required_number_count = 0
      config.password_required_special_character_count = 0
    end
  end

  describe 'validations' do
    subject { user }

    let(:user) { Isolated::UserContent.new(email: 'fred@flintstone.com', password: 'Bubb1234@#$!', password_confirmation: 'Bubb1234@#$!') }

    context 'when password is less than minimum length' do
      before { user.password = user.password_confirmation = '' }

      it { is_expected.not_to be_valid }
    end

    # rails skips password_confirmation validation if nil, make sure we continue
    # to support this behavior!
    context 'when password_confirmation is nil' do
      before { user.password_confirmation = nil }

      it { is_expected.to be_valid }
    end

    context 'when password is more than maximum length' do
      before { user.password = user.password_confirmation = 'a' * (Devise.password_length.max + 1) }

      it { is_expected.not_to be_valid }
    end

    context 'when password does not contain minimum uppercase characters' do
      before { user.password = user.password_confirmation = user.password.downcase }

      it { is_expected.not_to be_valid }
    end

    context 'when password does not contain minimum lowercase characters' do
      before { user.password = user.password_confirmation = user.password.upcase }

      it { is_expected.not_to be_valid }
    end

    context 'when password does not contain minimum numeric characters' do
      before { user.password = user.password_confirmation = 'bubbbubb@#$!' }

      it { is_expected.not_to be_valid }
    end

    context 'when password does not contain minimum special characters' do
      before { user.password = user.password_confirmation = 'bubb1234bubb' }

      it { is_expected.not_to be_valid }
    end

    context 'when password contains unknown characters' do
      before { user.password = user.password_confirmation = 'bubb1234bub:' }

      it { is_expected.not_to be_valid }
    end

    context 'when password contains minimum number of required characters' do
      it { is_expected.to be_valid }
    end
  end
end
