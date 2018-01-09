require 'spec_helper'
require 'support/string/locale_tools'

RSpec.describe Devise::Models::PasswordFrequentReusePrevention, type: :model do
  let(:password) { 'Bubb1234@#$!' }
  let(:user) do
    Isolated::UserFrequentReuse.new(
      email:                 'fred@flintstone.com',
      password:              password,
      password_confirmation: password
    )
  end

  describe 'config' do
    subject { Isolated::UserFrequentReuse }
    it { is_expected.to respond_to(:password_previously_used_count) }
  end

  describe 'associations' do
    subject { Isolated::UserFrequentReuse.new }
    it { is_expected.to have_many(:previous_passwords) }
  end

  describe 'validations' do
    subject { user }

    context 'when password has been used recently' do
      before do
        # create a previous_password
        user.save(validate: false)
        last_password = user.previous_passwords.unscoped.last
        last_password.created_at = Time.zone.now - 2.days
        last_password.save
        user.password = user.password_confirmation = user.password
        user.save
      end

      it { is_expected.not_to be_valid }

      it 'has the correct error message' do
        error_string = LocaleTools.replace_macros(
          I18n.translate('dppe.password_frequent_reuse_prevention.errors.messages.password_is_recent'),
          count: user.class.password_previously_used_count
        )
        expect(user.errors.full_messages).to include error_string
      end

      context 'and it is a different user' do
        let(:other_user) do
          Isolated::UserFrequentReuse.new(
            email:                 'wilma@flintstone.com',
            password:              user.password,
            password_confirmation: user.password
          )
        end
        subject { other_user }
        it { is_expected.to be_valid }
      end
    end

    context 'when password has not been used recently' do
      before { user.password = user.password_confirmation = user.password + 'Z' }
      it { is_expected.to be_valid }
    end
  end

  describe 'password updates' do
    let(:max_count) { Isolated::UserFrequentReuse.password_previously_used_count }
    let(:passwords) { (0..max_count).map { |c| user.password + c.to_s } }
    subject { user }

    context 'when password is set to same as current' do
      before do
        user.save
        user.password = user.password_confirmation = user.password
        user.save
      end

      it { is_expected.not_to be_valid }
    end

    context 'when no previous passwords exist yet' do
      it 'adds a new previous password' do
        expect { user.save }.to change { Devise::Models::PreviousPassword.count }.by(1)
      end
    end

    context 'when maximum number of passwords has not been reached' do
      before do
        passwords[0..max_count - 1].each do |password|
          user.password = user.password_confirmation = password
          user.save!
        end
      end

      it 'increases the number of previous passwords' do
        user.password = user.password_confirmation = passwords.last
        expect { user.save }.to change { Devise::Models::PreviousPassword.count }.by(1)
      end
    end

    context 'when maximum number of passwords has been reached' do
      before do
        passwords[0..max_count].each do |password|
          user.password = user.password_confirmation = password
          user.save!
        end
      end

      it 'does not change the number of previous passwords' do
        user.password = user.password_confirmation = passwords.last + 'Z'
        expect { user.save }.to change { Devise::Models::PreviousPassword.count }.by(0)
      end

      it 'destroys the oldest previous password' do
        oldest_password = user.previous_passwords.unscoped.first
        user.password = user.password_confirmation = passwords.last + 'Z'
        user.save
        expect(user.previous_passwords.find_by(id: oldest_password.id)).to be_nil
      end
    end
  end
end
