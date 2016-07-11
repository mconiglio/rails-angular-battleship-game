class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :x
      t.integer :y
      t.boolean :water
      t.boolean :shooted
      t.references :game, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :positions, [:shooted, :water], name: 'index_positions_on_shooted_and_water'
  end
end
