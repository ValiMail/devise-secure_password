require 'spec_helper'

RSpec.describe Devise::Models::PasswordDisallowsFrequentReuse, type: :model do
  let(:password) { 'Bubb1234@#$!' }
  let(:user) do
    Isolated::UserFrequentReuse.new(
      email: 'fred@flintstone.com',
      password: password,
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
        last_password = user.previous_passwords.first
        last_password.created_at = 2.days.ago
        last_password.save
        user.password = user.password_confirmation = user.password
        user.save
      end

      it { is_expected.not_to be_valid }

      it 'has the correct error message' do
        error_string = I18n.t(
          'secure_password.password_disallows_frequent_reuse.errors.messages.password_is_recent',
          count: user.class.password_previously_used_count
        )
        expect(user.errors.full_messages).to include error_string
      end

      context 'and it is a different user' do
        subject { other_user }

        let(:other_user) do
          Isolated::UserFrequentReuse.new(
            email: 'wilma@flintstone.com',
            password: user.password,
            password_confirmation: user.password
          )
        end

        it { is_expected.to be_valid }
      end
    end

    context 'when password has not been used recently' do
      before { user.password = user.password_confirmation = "#{user.password}Z" }

      it { is_expected.to be_valid }
    end
  end

  describe 'password updates' do
    subject { user }

    let(:max_count) { Isolated::UserFrequentReuse.password_previously_used_count }
    let(:passwords) { (0..max_count).map { |c| user.password + c.to_s } }

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

    context 'when previous passwords exist for multiple users' do
      let(:other_user) { Isolated::UserFrequentReuse.new(email: 'wilma@flintstone.com') }

      let(:dates) { (max_count - 1).downto(0).to_a.map { |c| c.days.ago } }

      @last_password = nil

      # rubocop:disable Style/CombinableLoops

      before do
        # add passwords for the target user
        passwords[0..max_count - 1].each_with_index do |password, index|
          user.password = user.password_confirmation = password
          user.save!
          previous_password = user.previous_passwords.first
          previous_password.created_at = previous_password.updated_at = dates[index]
          previous_password.save!
          @last_password = previous_password
        end
        # then add passwords for the other_user, these will appear in the db
        # most-recently based on id, which is what default_scope currently uses
        # to sort results.
        passwords[0..max_count - 1].each_with_index do |password, index|
          other_user.password = other_user.password_confirmation = password
          other_user.save!
          previous_password = other_user.previous_passwords.first
          previous_password.created_at = previous_password.updated_at = dates[index]
          previous_password.save!
        end
      end

      # rubocop:enable Style/CombinableLoops

      # NOTE: These tests are to prevent regression from an association scoping
      # bug where password ages from one user were sometimes compared with those
      # from another user.
      it 'returns the most-recent password' do
        expect(user.previous_passwords.first).to eq(@last_password)
      end
    end

    context 'when maximum number of passwords has been reached' do
      before do
        passwords[0..max_count].each do |password|
          user.password = user.password_confirmation = password
          user.save!
        end
      end

      # NOTE: These tests are to prevent regression from a change in strategy
      # after commit ccd2e51 up to which point old passwords were purged.
      it 'increases the number of previous passwords (all old passwords are preserved)' do
        user.password = user.password_confirmation = "#{passwords.last}Z"
        expect { user.save }.to change { Devise::Models::PreviousPassword.count }.by(1)
      end

      it 'preserves the oldest previous password (all old passwords are preserved)' do
        oldest_password = user.previous_passwords.last
        user.password = user.password_confirmation = "#{passwords.last}Z"
        user.save
        expect(user.previous_passwords.find_by(id: oldest_password.id)).not_to be_nil
      end
    end
  end
end
