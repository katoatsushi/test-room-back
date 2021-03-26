class CreateCustomerWeights < ActiveRecord::Migration[6.0]
  def change
    create_table :customer_weights do |t|
      t.float :weight
      t.references :customer
      t.timestamps
    end
  end
end
