require 'rails_helper'

RSpec.describe LeaderboardsController, type: :controller do

  describe '#index' do
    subject do
      get :index, params
    end

    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }

    let!(:game_for_user) { FactoryGirl.create(:game, points: 150, user: user) }
    let!(:game_for_other_user) { FactoryGirl.create(:game, points: 100, user: other_user) }

    context 'without parameters' do
      let(:params) { {} }

      it { should be_success }

      describe 'response body' do
        subject do
          get :index, params
          JSON.parse(response.body)
        end

        it 'returns an array ordered by user total points' do
          expect(subject['users'][0]['email']).to eql(user.email)
          expect(subject['users'][1]['email']).to eql(other_user.email)
          expect(subject['users_count']).to eql(2)
          expect(subject['current_page']).to eql(1)
          expect(subject['total_pages']).to eql(1)
        end
      end
    end

    context 'with parameters' do
      let(:params) { { page: page } }

      context 'when getting the first page' do
        let(:page) { 1 }

        it { should be_success }

        describe 'response body' do
          subject do
            get :index, params
            JSON.parse(response.body)
          end

          it 'returns an array ordered by user total points' do
            expect(subject['users'][0]['email']).to eql(user.email)
            expect(subject['users'][1]['email']).to eql(other_user.email)
            expect(subject['users_count']).to eql(2)
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
            expect(subject['users']).to match_array([])
            expect(subject['users_count']).to eql(2)
            expect(subject['current_page']).to eql(2)
            expect(subject['total_pages']).to eql(1)
          end
        end
      end
    end
  end
end
