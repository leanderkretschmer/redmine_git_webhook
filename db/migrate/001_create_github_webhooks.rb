class CreateGithubWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :github_webhooks do |t|
      t.integer :issue_id, null: false
      t.string :secret, null: false, limit: 255
      t.timestamps
    end

    add_index :github_webhooks, :issue_id, unique: true, name: 'index_github_webhooks_on_issue_id'
    
    # Foreign Key wird nicht hinzugefügt, da dies in einigen MySQL-Setups Probleme verursachen kann
    # Die Referenz-Integrität wird auf Application-Ebene durch das Model sichergestellt
  end
end

