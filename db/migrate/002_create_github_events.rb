class CreateGithubEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :github_events do |t|
      t.references :github_webhook, null: false, foreign_key: true
      t.string :event_type, null: false
      t.text :payload, null: false
      t.timestamps
    end

    add_index :github_events, :github_webhook_id
    add_index :github_events, :created_at
    add_index :github_events, :event_type
  end
end

