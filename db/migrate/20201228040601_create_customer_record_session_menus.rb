class CreateCustomerRecordSessionMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :customer_record_session_menus do |t|
      t.integer :time
      t.integer :weight
      t.references :fitness_third
      t.references :customer_record
      t.integer :fitness_id
      t.string :fitness_name
      t.string :fitness_third_name
      # t.text :detail
      t.timestamps
    end
  end
end
