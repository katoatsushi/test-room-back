class CreateFitnessFourths < ActiveRecord::Migration[6.0]
  def change
    create_table :fitness_fourths do |t|
      t.integer :time
      t.integer :set_num
      t.integer :calorie
      t.references :fitness_third
      t.timestamps
    end
  end
end
