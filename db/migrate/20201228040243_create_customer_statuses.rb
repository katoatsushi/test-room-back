class CreateCustomerStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :customer_statuses do |t|
      t.boolean :paid #有料会員の可否(通常プラン)
      t.boolean :room_plus #ルームプラスの入会の可否
      t.boolean :dozen_sessions #週3×4のセッションのプラン
      t.integer :numbers_of_contractnt # 1ヶ月に予約できる回数
      # t.references :customer
      t.belongs_to :customer, index: { unique: true }, foreign_key: true
      t.timestamps
    end
  end
end
