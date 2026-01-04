class CreateEventApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :event_applications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.datetime :applied_at
      t.datetime :canceled_at

      t.timestamps
    end

    add_index :event_applications, [:event_id, :user_id], unique: true
  end
end
