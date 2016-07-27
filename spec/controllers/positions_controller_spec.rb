require 'rails_helper'

RSpec.describe PositionsController, type: :controller do

  describe '#update' do
    subject { patch :update, id: position.id, game_id: game.id }

    context 'when user has signed in' do
      let(:user) { FactoryGirl.create(:user) }
      let(:game) { user.games.create }
      let(:position) { game.positions.offset(rand(game.positions.count)).first }

      context 'when updates one of his games' do
        before { sign_in(user, scope: :user) }

        it 'updates the requested position' do
          expect{ subject }.to change{ position.reload.shooted? }.from(false).to(true)
        end
      end

      context "when updates a game that doesn't belong" do
        before { sign_in(other_user, scope: :user) }
        let(:other_user) { FactoryGirl.create(:user) }

        it { should be_unauthorized }
        it { expect(JSON.parse(subject.body)['error']).to eq("You can't shoot this position.") }
      end
    end

    context 'when not logged' do
      let(:game) { FactoryGirl.create(:game) }
      let(:position) { game.positions.offset(rand(game.positions.count)).first }

      it { should be_unauthorized }
      it { expect(JSON.parse(subject.body)['error']).to eq("You can't shoot this position.") }
    end
  end
end
