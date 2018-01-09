require 'spec_helper'

RSpec.describe Devise::Models::PreviousPassword, type: :model do
  let(:password) { 'Bubb1234%$#!' }
  let(:user) do
    Isolated::UserFrequentReuse.new(
      email:                 'wilma@flintstone.com',
      password:              password,
      password_confirmation: password
    )
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:salt) }
    it { is_expected.to validate_presence_of(:encrypted_password) }
  end

  describe 'persistence' do
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
    let(:encrypted_passwords) { [] }

    before do
      ('A'..'F').each do |c|
        user.password = user.password_confirmation = password + c
        user.save(validate: false)
        # save the hash
        encrypted_passwords.push(user.encrypted_password)
      end
    end

    it 'returns entries in DESC order for default_scope' do
      user.previous_passwords.each_with_index do |p, i|
        expect(encrypted_passwords[-(i + 1)]).to eq(p.encrypted_password)
      end
    end
  end
end
