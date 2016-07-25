require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#games_ended' do
    subject { user.games_ended }

    let(:user) { FactoryGirl.create(:user) }

    context "when the user doesn't have games" do
      it { expect(subject.count).to eql(0) }
    end

    context 'when the user does have games' do

      context "when there aren't games ended" do
        before { 3.times { FactoryGirl.create(:game, user: user, ended_at: nil) } }

        it { expect(subject.count).to eql(0) }
      end

      context 'when there are games ended' do
        before do
          3.times { FactoryGirl.create(:game, user: user) }
          2.times { |i| FactoryGirl.create(:game, user: user, ended_at: game_end_time + i) }
        end

        let!(:game_end_time) { rand(1.days).seconds.ago }

        it { expect(subject.count).to eql(2) }
        it { expect(subject[0].ended_at).to be > subject[1].ended_at }
      end
    end
  end
end
