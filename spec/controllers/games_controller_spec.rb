require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { user.games.create }

  describe '#index' do
    before { sign_in(user, scope: :user) }
    subject { get :index }
    let(:game) { user.games.create }

    it 'assigns all games as @games' do
      expect{ subject }.to change{ assigns(:games) }.to([game])
    end
    it { should be_success }
  end

  describe '#show' do
    before { sign_in(user, scope: :user) }
    subject { get :show, id: game.id }
    let(:game) { user.games.create }

    it 'assigns the requested game as @game' do
      expect{ subject }.to change{ assigns(:game) }.to(game)
    end
    it { should be_success }
  end

  describe '#create' do
    subject { post :create }

    context 'when user has signed in' do
      before { sign_in(user, scope: :user) }
      it 'creates a new Game' do
        expect { subject }.to change(Game, :count).by(1)
      end

      it 'assigns a newly created game as @game' do
        expect{ subject }.to change{ assigns(:game) }.to be_a(Game)
      end

      it { should be_created }
    end

    context 'when not logged' do
      it { should be_unauthorized }
      it { expect(JSON.parse(subject.body)['error']).to eq('You have to authenticate to do this.') }
    end
  end
end
