class CreateFitnessThirds < ActiveRecord::Migration[6.0]
  def change
    create_table :fitness_thirds do |t|
      t.string :name
      t.references :fitness_second
      t.string :fitness_second_name
      t.boolean :set
      t.boolean :weight
      t.timestamps
    end
  end
end