class AddGamesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :games_count, :integer, default: 0

    add_index :users, :games_count, name: 'index_games_on_games_count'
  end
end
