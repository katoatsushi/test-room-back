class CreateTrainerInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :trainer_infos do |t|
      t.string :first_name
      t.string :last_name
      t.string :first_name_kana
      t.string :last_name_kana
      t.string :gender
      t.belongs_to :trainer, index: { unique: true }, foreign_key: true
      t.text :avatar_url

      # t.datetime :birthday
      # t.integer :age
      # t.string :gender
      # t.string :phonenumber
      # t.string :emergency_phonenumber

      # t.references :trainer
      t.timestamps
    end
  end
end
