class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :points
      t.integer :remaining_shots, default: 50
      t.datetime :ended_at
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :games, :ended_at, name: 'index_games_on_ended'
  end
end
