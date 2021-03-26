class CreateTrialSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :trial_sessions do |t|
      t.string :name
      t.text :address
      t.string :tel
      t.string :email
      t.text :details
      t.belongs_to :black_schedule, index: { unique: true }, foreign_key: true
      t.timestamps
    end
  end
end