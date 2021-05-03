class AddColumnToTrainer < ActiveRecord::Migration[6.0]
  def change
    add_column :trainers, :full_time, :boolean, default: false
  end
end
