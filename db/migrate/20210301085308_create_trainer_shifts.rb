class CreateTrainerShifts < ActiveRecord::Migration[6.0]
  def change
    create_table :trainer_shifts do |t|
      t.datetime :start
      t.datetime :finish
      t.references :trainer
      t.integer :store_id
      t.timestamps
    end
  end
end