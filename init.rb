require 'redmine'

Redmine::Plugin.register :redmine_git_webhook do
  name 'Redmine GitHub Webhook Plugin'
  author 'Leander Kretschmer'
  description 'Plugin zur Integration von GitHub Webhooks in Redmine Tickets'
  version '0.0.1'
  url 'https://github.com/leanderkretschmer/redmine_git_webhook'
  author_url 'https://github.com/leanderkretschmer'

  project_module :github_webhook do
    permission :view_github_webhook, :github_webhooks => [:show]
    permission :manage_github_webhook, :github_webhooks => [:create, :update, :destroy]
  end
end

# Tracker "GitHub" beim Plugin-Laden erstellen und Hooks laden
Rails.configuration.to_prepare do
  # Hooks-Datei laden
  require File.join(File.dirname(__FILE__), 'lib', 'redmine_git_webhook', 'hooks')
  
  # Tracker "GitHub" erstellen
  unless Tracker.find_by(name: 'GitHub')
    Tracker.create!(
      name: 'GitHub',
      is_in_chlog: true,
      is_in_roadmap: true,
      fields_bits: 0,
      default_status_id: IssueStatus.default&.id || 1
    )
  end
end

