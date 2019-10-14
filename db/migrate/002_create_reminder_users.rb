class CreateReminderUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :reminder_users do |t|
      t.references :reminder_entry, null: false
      t.references :user, null: false
    end

    add_index :reminder_users, :reminder_entry_id
  end
end
