class CreateTrainerFitnesses < ActiveRecord::Migration[6.0]
  def change
    create_table :trainer_fitnesses do |t|
      t.references :trainer
      t.references :fitness
      t.timestamps
    end
  end
end
