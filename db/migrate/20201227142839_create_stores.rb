class CreateStores < ActiveRecord::Migration[6.0]
  def change
    create_table :stores do |t|
      t.string :store_name
      t.text :store_address
      t.string :tel
      t.integer :number_of_rooms
      t.references :company
      t.timestamps
    end
  end
end
