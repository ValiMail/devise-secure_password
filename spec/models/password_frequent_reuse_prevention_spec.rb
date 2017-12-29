require 'spec_helper'
require 'support/string/locale_tools'

RSpec.describe Devise::Models::PasswordFrequentReusePrevention, type: :model do
  LocaleTools = ::Support::String::LocaleTools

  describe 'config' do
    subject { User }
    it { is_expected.to respond_to(:password_previously_used_count) }
  end

  describe 'associations' do
    subject { User.new }
    it { is_expected.to have_many(:previous_passwords) }
  end

  describe 'validations' do
    let(:user) { User.new(email: 'fred@flintstone.com', password: 'Bubb1234@#$!') }
    subject { user }

    context 'when password has been used recently' do
      before { user.save && user.save }

      it { is_expected.not_to be_valid }

      it 'has the correct error message' do
        error_string = LocaleTools.replace_macros(
          I18n.translate('dppe.password_frequent_reuse_prevention.errors.messages.password_is_recent'),
          count: user.class.password_previously_used_count
        )
        expect(user.errors.full_messages).to include error_string
      end

      context 'and it is a different user' do
        let(:other_user) { User.new(email: 'wilma@flintstone.com', password: user.password) }
        subject { other_user }
        it { is_expected.to be_valid }
      end
    end

    context 'when password has not been used recently' do
      before { user.password = user.password + 'Z' }
      it { is_expected.to be_valid }
    end
  end

  describe 'password updates' do
    let(:user) { User.new(email: 'fred@flintstone.com', password: 'Bubb1234@#$!') }
    let(:max_count) { User.password_previously_used_count }
    let(:passwords) { (0..max_count).map { |c| user.password + c.to_s } }

    context 'when maximum number of passwords has not been reached' do
      before do
        passwords[0..max_count - 1].each do |password|
          user.password = password
          user.save!
        end
      end

      it 'increases the number of previous passwords' do
        user.password = passwords.last
        expect { user.save }.to change { Devise::Models::PreviousPassword.count }.by(1)
      end
    end

    context 'when maximum number of passwords has been reached' do
      before do
        passwords[0..max_count].each do |password|
          user.password = password
          user.save!
        end
      end

      it 'does not change the number of previous passwords' do
        user.password = passwords.last + 'Z'
        expect { user.save }.to change { Devise::Models::PreviousPassword.count }.by(0)
      end

      it 'destroys the oldest previous password' do
        last_record = user.previous_passwords.last
        user.password = passwords.last + 'Z'
        user.save
        expect(user.previous_passwords.find_by(id: last_record.id)).to be_nil
      end
    end
  end
end
