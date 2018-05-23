require 'spec_helper'

RSpec.describe Devise::SecurePassword::Controllers::ActiveHelpers, type: :controller do
  let(:password) { 'Bubb1234%$#!' }
  let(:user) do
    User.create(
      email:                 'george@jetson.com',
      password:              password,
      password_confirmation: password
    )
  end

  context 'ApplicationController' do
    controller(ApplicationController) do; end

    describe '#authenticate_secure_password_expired?' do
      subject { controller.authenticate_secure_password_expired? }

      context 'warden is not authenticated' do
        it { is_expected.to be false }
      end

      context 'warden authenticated' do
        before { sign_in user }

        context 'w/o session' do
          before { allow(controller.warden).to receive(:session).and_return nil }
          it { is_expected.to be false }
        end

        context 'w/ session' do
          context 'no secure_password_expired information' do
            before { allow(controller.warden).to receive(:session).and_return({}) }
            it { is_expected.to be false }
          end

          context 'secure_password_expired is false' do
            before { allow(controller.warden).to receive(:session).and_return({ 'secure_password_expired' => false }) }
            it { is_expected.to be false }
          end

          context 'secure_password_expired is other value' do
            before { allow(controller.warden).to receive(:session).and_return({ 'secure_password_expired' => 'other value' }) }
            it { is_expected.to be false }
          end

          context 'secure_password_expired is true' do
            before { allow(controller.warden).to receive(:session).and_return({ 'secure_password_expired' => true }) }
            it { is_expected.to be true }
          end
        end
      end
    end

    describe '#authenticate_secure_password!' do
      before do
        sign_in user
        allow(controller).to receive(:redirect_to)
        controller.authenticate_secure_password!
      end

      context 'w/ expired' do
        before do
          allow(controller).to receive(:authenticate_secure_password_expired?).and_return true
          subject
        end

        it 'redirects with alert flash' do
          expect(controller).to_not have_received(:redirect_to).with \
            :edit_user_password_policy, \
            alert: 'hi'
        end
      end

      context 'w/ not expired' do
        before { allow(controller).to receive(:authenticate_secure_password_expired?).and_return false }
        it { expect(controller).to_not have_received(:redirect_to) }
      end
    end

    describe '#authenticate_secure_password_path' do
      subject { controller.authenticate_secure_password_path }

      context 'w/o warden.user' do
        it { is_expected.to be_nil }
      end

      context 'w/ warden.user' do
        before { sign_in user }
        it { is_expected.to eq :edit_user_password_with_policy }
      end
    end
  end

  context 'Devise Controller' do
    controller(Devise::SessionsController) do; end

    describe '#authenticate_secure_password_expired?' do
      subject { controller.authenticate_secure_password_expired? }

      before do
        sign_in user
        allow(controller.warden).to receive(:session).and_return({ 'secure_password_expired' => true })
      end

      it 'does not prompt for password within a Devise controller' do
        is_expected.to be false
      end
    end
  end
end
