class CreateGithubWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :github_webhooks do |t|
      t.references :issue, null: false, foreign_key: true
      t.string :secret, null: false
      t.timestamps
    end

    add_index :github_webhooks, :issue_id, unique: true
  end
end

