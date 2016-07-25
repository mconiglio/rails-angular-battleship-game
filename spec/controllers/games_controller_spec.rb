require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }
  let(:game) { user.games.create }

  describe '#index' do
    subject { get :index, params }
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in(user, scope: :user)
      2.times { FactoryGirl.create(:game, user: user, ended_at: rand(1.days).seconds.ago) }
    end

    describe 'without parameters' do
      let(:params) { {} }

      it { should be_success }

      describe 'response body' do
        subject do
          get :index, params
          JSON.parse(response.body)
        end

        it 'returns an array ordered by the ended time of the game' do
          expect(subject['games'][0]['ended_at']).to be > subject['games'][1]['ended_at']
          expect(subject['games_count']).to eql(2)
          expect(subject['current_page']).to eql(1)
          expect(subject['total_pages']).to eql(1)
        end
      end
    end

    describe 'with parameters' do
      let(:params) { { page: page } }

      context 'when getting the first page' do
        let(:page) { 1 }

        it { should be_success }

        describe 'response body' do
          subject do
            get :index, params
            JSON.parse(response.body)
          end

          it 'returns an array ordered by the ended time of the game' do
            expect(subject['games'][0]['ended_at']).to be > subject['games'][1]['ended_at']
            expect(subject['games_count']).to eql(2)
            expect(subject['current_page']).to eql(1)
            expect(subject['total_pages']).to eql(1)
          end
        end
      end

      context 'when getting an empty page' do
        let(:page) { 2 }

        it { should be_success }

        describe 'response body' do
          subject do
            get :index, params
            JSON.parse(response.body)
          end

          it 'returns an empty users array and the total count of users' do
            expect(subject['games']).to match_array([])
            expect(subject['games_count']).to eql(2)
            expect(subject['current_page']).to eql(2)
            expect(subject['total_pages']).to eql(1)
          end
        end
      end
    end
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
