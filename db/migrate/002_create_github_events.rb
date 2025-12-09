class CreateGithubEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :github_events do |t|
      t.integer :github_webhook_id, null: false
      t.string :event_type, null: false, limit: 255
      t.text :payload, null: false
      t.timestamps
    end

    add_index :github_events, :github_webhook_id, name: 'index_github_events_on_github_webhook_id'
    add_index :github_events, :created_at, name: 'index_github_events_on_created_at'
    add_index :github_events, :event_type, name: 'index_github_events_on_event_type'
    
    # Foreign Key wird nicht hinzugefügt, da dies in einigen MySQL-Setups Probleme verursachen kann
    # Die Referenz-Integrität wird auf Application-Ebene durch das Model sichergestellt
  end
end

