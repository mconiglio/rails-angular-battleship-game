require 'rails_helper'

RSpec.describe Position, type: :model do
  describe 'creating a new position' do
    let(:position) { Position.new }

    it { expect(position.shooted).to be_falsey }
    it { expect(position.water).to be_truthy }
  end

  describe '#shoot!' do
    subject { position.shoot! }

    context 'when the position is empty' do
      let(:game) { FactoryGirl.create(:game) }
      let(:position) { game.positions.create(water: true) }

      it { expect{ subject }.to change{ position.shooted }.from(false).to(true) }
    end

    context "when the position isn't empty" do
      let(:game) { FactoryGirl.create(:game) }
      let(:position) { game.positions.create(water: false) }

      it { expect{ subject }.to change{ position.shooted }.from(false).to(true) }
    end
  end
end
