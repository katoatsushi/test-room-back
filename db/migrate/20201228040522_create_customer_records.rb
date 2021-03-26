class CreateCustomerRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :customer_records do |t|
      t.references :appointment
      t.references :customer
      t.references :trainer
      t.datetime :apo_time
      t.text :detail
      t.timestamps
    end
  end
end
