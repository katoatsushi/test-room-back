class CreateCustomerMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :customer_menus do |t|
      t.string :name
      t.integer :point
      t.integer :company_id
      t.timestamps
    end
  end
end
