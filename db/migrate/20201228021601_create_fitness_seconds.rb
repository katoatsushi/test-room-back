class CreateFitnessSeconds < ActiveRecord::Migration[6.0]
  def change
    create_table :fitness_seconds do |t|
      t.string :name
      t.references :fitness
      t.timestamps
    end
  end
end
