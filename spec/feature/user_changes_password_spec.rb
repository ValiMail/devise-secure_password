require 'spec_helper'

RSpec.describe 'User changes password', type: :feature do
  let(:password) { 'Bubb1234%$#!' }
  let(:user) do
    User.new(
      email:                 'betty@rubble.com',
      password:              password,
      password_confirmation: password
    )
  end

  before do
    Devise.setup { |config| config.password_minimum_age = 1.day }
  end

  after do
    Devise.setup { |config| config.password_minimum_age = 0.days }
  end

  context 'with an invalid password', js: true do
    let(:bad_password) { 'a' * 12 }
    before do
      user.save
      login_as(user, scope: :user)
      visit '/users/change_password/edit'
    end

    scenario 'remains on page and displays error messages' do
      expect(page).to have_content(/Change your password/i)
      fill_in 'user_current_password', with: password
      fill_in 'user_password', with: bad_password
      fill_in 'user_password_confirmation', with: bad_password
      find(:xpath, ".//input[@type='submit' and @name='commit']").click

      expect(page).to have_content(/Change your password/i)
      within '#error_explanation' do
        expect(page).to have_content(/Password cannot be changed more than once per 1 day/i)
      end
    end
  end

  context 'with a valid password', js: true do
    let(:new_password) { user.password + 'Z' }
    before do
      user.save
      last_password = user.previous_passwords.first
      last_password.created_at = Time.zone.now - 2.days
      last_password.save
      login_as(user, scope: :user)
      visit '/users/change_password/edit'
    end

    scenario 'redirects to home page and displays success message' do
      fill_in 'user_current_password', with: password
      fill_in 'user_password', with: new_password
      fill_in 'user_password_confirmation', with: new_password
      find(:xpath, ".//input[@type='submit' and @name='commit']").click

      expect(page).to have_content(/Your password has been updated/i)
      expect(page).not_to have_selector('#error_explanation')
    end
  end
end
