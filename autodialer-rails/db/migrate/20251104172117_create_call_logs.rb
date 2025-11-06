class CreateCallLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :call_logs do |t|
      t.string :phone_number
      t.string :status
      t.integer :duration
      t.text :error_message
      t.string :call_sid

      t.timestamps
    end
    
    add_index :call_logs, :phone_number
    add_index :call_logs, :status
    add_index :call_logs, :call_sid
    add_index :call_logs, :created_at
  end
end