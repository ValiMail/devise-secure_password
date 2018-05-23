require 'spec_helper'

RSpec.describe 'User logs in', type: :feature do
  let(:password) { 'Bubb1234%$#!' }
  let(:new_password) { 'Dubb9874%$#!' }
  let(:user) do
    User.create(
      email:                 'betty@rubble.com',
      password:              password,
      password_confirmation: password
    )
  end

  def expire_user_password
    last_password = user.previous_passwords.first
    last_password.created_at = Time.zone.now - User.password_maximum_age
    last_password.save
  end

  def sign_in_user
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find(:xpath, ".//input[@type='submit' and @name='commit']").click
  end

  context 'with a password older than password_maximum_age', js: true do
    before { expire_user_password }

    scenario 'redirected to the change password page' do
      visit '/users/sign_in'

      expect(page).to have_content(/Log in/i)
      expect(page).to have_selector('input[type="submit"]')
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      find(:xpath, ".//input[@type='submit' and @name='commit']").click

      expect(page).to have_content(/Change your password/i)
      within '#error_explanation' do
        expect(page).to have_content 'Your password has expired'
      end

      expect(page).to have_selector('form.new_user')
      within 'form.new_user' do
        expect(page).to have_selector('label[for="user_current_password"]', text: /Current password/i)
        expect(page).to have_selector('input[type="password"]#user_current_password')
        expect(page).to have_selector('label[for="user_password"]', text: /New password/i)
        expect(page).to have_selector('input[type="password"]#user_password')
        expect(page).to have_selector('label[for="user_password_confirmation"]', text: /Confirm new password/i)
        expect(page).to have_selector('input[type="password"]#user_password_confirmation')
        expect(page).to have_selector('input[type="submit"][value="Change my password"]')
      end
    end

    scenario 'attempts to access application without updating password', js: true do
      visit '/users/sign_in'
      sign_in_user

      expect(page).to have_current_path('/users/change_password/edit')
      expect(page).to have_content(/Change your password/i)
      within '#error_explanation' do
        expect(page).to have_content 'Your password has expired'
      end

      visit '/'
      expect(page).to have_current_path('/users/change_password/edit')
    end

    scenario 'accesses application after updating password', js: true do
      visit '/users/sign_in'
      sign_in_user

      expect(page).to have_current_path('/users/change_password/edit')
      fill_in 'user_current_password', with: password
      fill_in 'user_password', with: new_password
      fill_in 'user_password_confirmation', with: new_password
      find(:xpath, ".//input[@type='submit' and @name='commit']").click

      expect(page).to have_current_path('/')
    end
  end

  context 'with a password newer than password_maximum_age', js: true do
    before do
      visit '/users/sign_in'
    end

    scenario 'is not redirected to change password page' do
      expect(page).to have_content(/Log in/i)
      expect(page).to have_selector('input[type="submit"]')
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      find(:xpath, ".//input[@type='submit' and @name='commit']").click

      expect(page).to have_content(/Signed in/i)
      expect(page).not_to have_selector('#error_explanation')
    end
  end
end
