require 'spec_helper'

RSpec.describe Devise::Models::PasswordContentEnforcement, type: :model do
  describe 'validations' do
    let(:user) { Isolated::UserContent.new(email: 'fred@flintstone.com', password: 'Bubb1234@#$!', password_confirmation: 'Bubb1234@#$!') }
    subject { user }

    context 'when password does not contain minimum uppercase characters' do
      before { user.password = user.password_confirmation = user.password.downcase }
      it { is_expected.not_to be_valid }
    end

    context 'when password does not contain minimum lowercase characters' do
      before { user.password = user.password_confirmation = user.password.upcase }
      it { is_expected.not_to be_valid }
    end

    context 'when password does not contain minimum number characters' do
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
      it { should be_valid }
    end
  end
end
