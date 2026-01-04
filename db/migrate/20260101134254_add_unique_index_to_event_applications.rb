class AddUniqueIndexToEventApplications < ActiveRecord::Migration[7.1]
  def change
    add_index :event_applications, [:event_id, :user_id], unique: true
  end
end
