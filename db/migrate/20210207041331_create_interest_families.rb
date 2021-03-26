class CreateInterestFamilies < ActiveRecord::Migration[6.0]
  def change
    create_table :interest_families do |t|
      t.string :name
      t.timestamps
    end
  end
end
