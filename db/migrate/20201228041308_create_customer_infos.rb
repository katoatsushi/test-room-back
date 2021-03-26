class CreateCustomerInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :customer_infos do |t|
      t.integer :age
      t.date :birthday
      t.string :postal_code
      t.string :address
      t.string :gender
      t.string :phone_number
      t.string :emergency_phone_number
      t.integer :job_id
      t.string :job_name
      t.belongs_to :customer, index: { unique: true }, foreign_key: true
      t.text :avatar_url
      t.timestamps
    end
  end
end
