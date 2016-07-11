require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'creating a new game' do
    let(:game) { Game.create }

    it { expect(game.positions.count).to eql(100) }
    it { expect(game.positions.where(water: false).count).to eql(Game::GAME_SHIPS.sum) }
    it { expect(game.remaining_shots).to eql(50) }
    it { expect(game.ended_at).to be_nil }
  end

  describe '#decrement_remaining_shots' do
    subject { game.decrement_remaining_shots(missed) }
    let(:game) { Game.create(created_at: 1.hour.ago) }

    context "when the game doesn't end" do
      context 'when passing true as argument' do
        let(:missed) { true }

        it { expect{ subject }.to change{ game.remaining_shots }.by(-1) }
      end

      context 'when passing false as argument' do
        let(:missed) { false }

        it { expect{ subject }.not_to change{ game.remaining_shots } }
      end
    end

    context 'when the game ends' do
      context 'when the position shooted is empty' do
        before do
          game.positions.where(water: true).limit(49).each { |pos| game.shoot_position!(pos) }
        end
        let(:missed) { true }

        it 'sets the ended_at value' do
          expect{ subject }.to change{ game.ended_at.class }.from(NilClass)
                                   .to(ActiveSupport::TimeWithZone)
        end
        it 'sets the points value' do
          expect{ subject }.to change{ game.points.class }.from(NilClass)
                                   .to(Fixnum)
        end
      end

      context "when the position shooted isn't empty" do
        before do
          game.positions.where(water: false).limit(Game::GAME_SHIPS.sum - 1)
              .each { |pos| game.shoot_position!(pos) }
        end
        let(:position) { game.positions.where(water: false, shooted: false).first }

        it 'sets the ended_at value' do
          expect{ game.shoot_position!(position) }.to change{ game.ended_at.class }.from(NilClass)
                   .to(ActiveSupport::TimeWithZone)
        end
        it 'sets the points value' do
          expect{ game.shoot_position!(position) }.to change{ game.points.class }.from(NilClass)
                                   .to(Fixnum)
        end
      end
    end
  end

  describe '#shots_on_target' do
    subject { game.shots_on_target }
    let(:game) { Game.create }

    context 'when shooting a water position' do
      let(:position) { game.positions.where(water: true).first }

      it "shouldn't change the shots_on_target" do
        expect { position.shoot! }.not_to change{ subject }
      end
    end

    context 'when shooting a ship position' do
      let(:position) { game.positions.where(water: false).first }

      it 'should increment the shots_on_target by one' do
        expect { position.shoot! }.to change{ game.shots_on_target }.by(1)
      end
    end
  end

  describe '#shots_missed' do
    subject { game.shots_missed }
    let(:game) { Game.create }

    context 'when shooting a ship position' do
      let(:position) { game.positions.where(water: false).first }

      it "shouldn't change the shots_on_target" do
        expect { position.shoot! }.not_to change{ subject }
      end
    end

    context 'when shooting a water position' do
      let(:position) { game.positions.where(water: true).first }

      it 'should increment the shots_on_target by one' do
        expect { position.shoot! }.to change{ game.shots_missed }.by(1)
      end
    end
  end

  describe '#time_played' do
    subject { game.time_played }

    context 'when game has ended' do
      let(:game) { Game.create(created_at: 1.hour.ago, ended_at: Time.now) }

      it 'returns the difference between the ended and the created time' do
        is_expected.to eql((game.ended_at - game.created_at).to_i)
      end
    end

    context "when game hasn't ended" do
      let(:game) { Game.create(created_at: 1.hour.ago) }

      it 'returns the seconds passed from the start of the game' do
        is_expected.to eql((Time.now - game.created_at).to_i)
      end
    end
  end

  describe '#finished?' do
    subject { game.finished? }

    context 'when game has ended' do
      let(:game) { Game.create(created_at: 1.hour.ago, ended_at: Time.now) }

      it 'returns the difference between the ended and the created time' do
        is_expected.to be_truthy
      end
    end

    context "when game hasn't ended" do
      let(:game) { Game.create(created_at: 1.hour.ago) }

      it 'returns the seconds passed from the start of the game' do
        is_expected.to be_falsey
      end
    end
  end
end
