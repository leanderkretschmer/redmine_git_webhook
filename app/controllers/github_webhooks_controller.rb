class GithubWebhooksController < ApplicationController
  before_action :find_issue
  before_action :authorize, only: [:show, :create, :update, :destroy]
  before_action :find_github_webhook, only: [:show, :update, :destroy]

  def show
    @github_webhook ||= GithubWebhook.new(issue: @issue)
    @github_events = @github_webhook.persisted? ? @github_webhook.github_events.order(created_at: :desc) : []
    redirect_to issue_path(@issue, tab: 'github')
  end

  def create
    @github_webhook = GithubWebhook.new(issue: @issue)
    if @github_webhook.save
      flash[:notice] = l(:notice_github_webhook_created)
      redirect_to issue_path(@issue, tab: 'github')
    else
      flash[:error] = l(:error_github_webhook_create_failed)
      redirect_to issue_path(@issue, tab: 'github')
    end
  end

  def update
    if @github_webhook.update(github_webhook_params)
      flash[:notice] = l(:notice_github_webhook_updated)
    else
      flash[:error] = l(:error_github_webhook_update_failed)
    end
    redirect_to issue_path(@issue, tab: 'github')
  end

  def destroy
    @github_webhook.destroy
    flash[:notice] = l(:notice_github_webhook_deleted)
    redirect_to issue_path(@issue, tab: 'github')
  end

  private

  def find_issue
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_github_webhook
    @github_webhook = GithubWebhook.find_by(issue_id: @issue.id)
  end

  def github_webhook_params
    params.require(:github_webhook).permit(:secret)
  end
end

