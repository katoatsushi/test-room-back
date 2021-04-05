class CreateAppointments < ActiveRecord::Migration[6.0]
  def change
    create_table :appointments do |t|
      # 始まる時間
      t.datetime :appointment_time
      # お客様
      t.references :customer
      # 備考
      t.text :free_box
       # 店舗選択
      t.integer :store_id
      t.string :store_name
       # セッション項目
      t.references :fitness
      t.string :fitness_name
      t.boolean :finish, default: false
      t.timestamps
    end
  end
end
