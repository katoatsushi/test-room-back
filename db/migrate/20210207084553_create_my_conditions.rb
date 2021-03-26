class CreateMyConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :my_conditions do |t|
      # t.float :weight
      t.float :height
      t.references :customer
      t.timestamps
    end
  end
end
