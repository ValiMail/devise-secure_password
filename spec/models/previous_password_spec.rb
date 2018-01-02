require 'spec_helper'

RSpec.describe Devise::Models::PreviousPassword, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:salt) }
    it { is_expected.to validate_presence_of(:encrypted_password) }
  end

  describe 'persistence' do
    let(:user) { UserFrequentReuse.new(email: 'wilma@flintstone.com', password: 'Bubb1234%$#!') }
    context 'when creating a user' do
      it 'increases number of previous passwords' do
        expect { user.save }.to change { user.previous_passwords.count }.by(1)
      end
    end

    context 'when destroying a user' do
      before { user.save }
      it 'decreases number of previous passwords' do
        expect { user.destroy }.to change { Devise::Models::PreviousPassword.count }.by(-1)
      end
    end
  end

  describe 'scopes' do
    pending 'check that entries are returned in proper order'
  end
end
