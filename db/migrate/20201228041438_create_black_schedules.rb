class CreateBlackSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :black_schedules do |t|
      t.datetime :not_free_time_start
      t.datetime :not_free_time_finish
      t.boolean :customer_service
      t.integer :store_id
      t.references :admin
      t.references :company
      t.timestamps
    end
  end
end
