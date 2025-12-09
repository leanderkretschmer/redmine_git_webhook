module RedmineGitWebhook
  class Hooks < Redmine::Hook::ViewListener
    # Tab-Link hinzufügen (wird in der Issue-Ansicht angezeigt)
    def view_issues_show_tabs(context = {})
      issue = context[:issue]
      controller = context[:controller]
      return '' unless issue && issue.project.module_enabled?(:github_webhook)

      controller.send(:render_to_string, {
        partial: 'github_webhooks/tab_link',
        locals: { issue: issue, controller: controller }
      })
    end

    # Tab-Content anzeigen (wird angezeigt, wenn Tab aktiv ist)
    def view_issues_show_details_bottom(context = {})
      issue = context[:issue]
      controller = context[:controller]
      return '' unless issue && issue.project.module_enabled?(:github_webhook)

      tab = controller.params[:tab]
      if tab == 'github'
        github_webhook = GithubWebhook.find_by(issue_id: issue.id)
        github_webhook ||= GithubWebhook.new(issue: issue)
        github_events = github_webhook.persisted? ? github_webhook.github_events.order(created_at: :desc) : []

        controller.send(:render_to_string, {
          partial: 'github_webhooks/tab_content',
          locals: { 
            issue: issue,
            github_webhook: github_webhook,
            github_events: github_events,
            controller: controller
          }
        })
      else
        ''
      end
    end
  end
end

