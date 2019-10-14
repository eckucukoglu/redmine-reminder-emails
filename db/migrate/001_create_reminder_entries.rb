class CreateReminderEntries < ActiveRecord::Migration[4.2]
  def change
    create_table :reminder_entries do |t|
      t.references :project, null: false
      t.references :tracker, :default => 0
      t.integer :days, null: false
      t.string :env, null: false
    end

    add_index :reminder_entries, :project_id
  end
end
