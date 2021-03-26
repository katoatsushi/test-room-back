class CreateCustomerInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :customer_interests do |t|
      t.references :customer
      t.references :interest
      t.timestamps
    end
  end
end
