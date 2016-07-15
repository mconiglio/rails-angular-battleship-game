require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#create' do
    subject { post :create, user: user }
    let(:user) { { email: email, password: password, password_confirmation: password_confirmation } }

    context 'without parameters' do
      let(:email) {}
      let(:password) {}
      let(:password_confirmation) {}

      it { should be_unauthorized }
      it { expect(JSON.parse(subject.body)['error']).to eq('Invalid email or passwords.') }
    end

    context 'with parameters' do
      context 'with wrong parameters' do
        context 'without email' do
          let(:email) {}
          let(:password) { 'somepassword' }
          let(:password_confirmation) { 'somepassword' }

          it { should be_unauthorized }
          it { expect(JSON.parse(subject.body)['error']).to eq('Invalid email or passwords.') }
        end

        context 'without password' do
          let(:email) { 'someemail@example.com' }
          let(:password) {}
          let(:password_confirmation) {}

          it { should be_unauthorized }
          it { expect(JSON.parse(subject.body)['error']).to eq('Invalid email or passwords.') }
        end

        context 'with different passwords' do
          let(:email) { 'someemail@example.com' }
          let(:password) { 'somepassword' }
          let(:password_confirmation) { 'otherpassword' }

          it { should be_unauthorized }
          it { expect(JSON.parse(subject.body)['error']).to eq('Invalid email or passwords.') }
        end
      end

      context 'with correct parameters' do
        let(:email) { 'someemail@example.com' }
        let(:password) { 'somepassword' }
        let(:password_confirmation) { 'somepassword' }

        it { should be_success }
        it { expect(JSON.parse(subject.body)['email']).to eq('someemail@example.com') }
        it { expect{ subject }.to change{ User.count }.by(1) }
      end
    end
  end

  describe '#update' do
    before { sign_in(some_user, scope: :user) }
    subject { patch 'update', user: user }
    let(:some_user) { FactoryGirl.create(:user, password: 'somepassword', password_confirmation: 'somepassword') }
    let(:user) { { password: password, password_confirmation: password_confirmation, current_password: current_password } }

    context 'without parameters' do
      let(:password) {}
      let(:password_confirmation) {}
      let(:current_password) {}

      it { should be_unauthorized }
      it { expect(JSON.parse(subject.body)['error']).to eq('Invalid password.') }
    end

    context 'with parameters' do
      context 'with wrong parameters' do
        context 'without current password' do
          let(:password) { 'somepassword' }
          let(:password_confirmation) { 'somepassword' }
          let(:current_password) { '' }

          it { should be_unauthorized }
          it { expect(JSON.parse(subject.body)['error']).to eq('Invalid password.') }
        end

        context 'with empty password and password confirmation' do
          let(:password) { '' }
          let(:password_confirmation) { '' }
          let(:current_password) { 'somepassword' }

          it { should be_unauthorized }
          it { expect(JSON.parse(subject.body)['error']).to eq('Invalid email or passwords.') }
        end

        context 'with different passwords' do
          let(:password) { 'otherpassword' }
          let(:password_confirmation) { 'differentpassword' }
          let(:current_password) { 'somepassword' }

          it { should be_unauthorized }
          it { expect(JSON.parse(subject.body)['error']).to eq('Invalid email or passwords.') }
        end

        context 'with wrong current password' do
          let(:password) { 'otherpassword' }
          let(:password_confirmation) { 'otherpassword' }
          let(:current_password) { 'wrongpassword' }

          it { should be_unauthorized }
          it { expect(JSON.parse(subject.body)['error']).to eq('Invalid password.') }
        end
      end

      context 'with correct parameters' do
        let(:password) { 'otherpassword' }
        let(:password_confirmation) { 'otherpassword' }
        let(:current_password) { 'somepassword' }

        describe 'the response' do
          it { should be_success }
          it { expect(JSON.parse(subject.body)['email']).to eq(some_user.email) }
        end

        describe 'the user result' do
          subject do
            patch 'update', user: user
            User.find_by_email(some_user.email)
          end

          it { expect(subject.valid_password?('otherpassword')).to be_truthy }
        end
      end
    end
  end
end
