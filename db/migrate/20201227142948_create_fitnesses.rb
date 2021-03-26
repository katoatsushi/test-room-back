class CreateFitnesses < ActiveRecord::Migration[6.0]
  def change
    create_table :fitnesses do |t|
      t.string :name
      t.references :company
      t.timestamps
    end
  end
end
