class CreateEvaluations < ActiveRecord::Migration[6.0]
  def change
    create_table :evaluations do |t|
      t.references :trainer
      t.string :trainer_name
      t.references :customer
      t.references :customer_record
      t.integer :food_score
      t.integer :trainer_score
      t.timestamps
    end
  end
end
