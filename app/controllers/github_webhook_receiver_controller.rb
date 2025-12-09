class GithubWebhookReceiverController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :check_if_login_required

  before_action :find_github_webhook
  before_action :verify_signature, only: [:receive]

  def receive
    event_type = request.headers['X-GitHub-Event'] || 'unknown'
    payload_hash = JSON.parse(@request_body)

    @github_webhook.github_events.create!(
      event_type: event_type,
      payload: payload_hash
    )

    # Nachricht als Journal-Eintrag zum Ticket hinzufügen
    journal = @github_webhook.issue.init_journal(User.anonymous)
    journal.notes = format_event_message(event_type, payload_hash)
    journal.save

    render json: { status: 'ok' }, status: :ok
  rescue JSON::ParserError => e
    render json: { error: 'Invalid JSON' }, status: :bad_request
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    Rails.logger.error "GitHub Webhook Error: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: { error: 'Internal server error' }, status: :internal_server_error
  end

  private

  def find_github_webhook
    @github_webhook = GithubWebhook.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Webhook not found' }, status: :not_found
  end

  def verify_signature
    @request_body = request.body.read
    signature = request.headers['X-Hub-Signature-256']
    
    return render json: { error: 'Missing signature' }, status: :unauthorized unless signature

    expected_signature = "sha256=#{OpenSSL::HMAC.hexdigest('sha256', @github_webhook.secret, @request_body)}"

    unless ActiveSupport::SecurityUtils.secure_compare(signature, expected_signature)
      render json: { error: 'Invalid signature' }, status: :unauthorized
    end
  end

  def format_event_message(event_type, payload)
    case event_type
    when 'push'
      commits = payload['commits'] || []
      ref = payload['ref'] || ''
      branch = ref.gsub('refs/heads/', '')
      repo = payload.dig('repository', 'full_name') || 'Repository'
      pusher = payload.dig('pusher', 'name') || 'Unknown'
      
      message = "GitHub Push Event\n"
      message += "Repository: #{repo}\n"
      message += "Branch: #{branch}\n"
      message += "Pusher: #{pusher}\n"
      message += "Anzahl Commits: #{commits.length}\n\n"
      
      commits.first(5).each do |commit|
        message += "• #{commit['message']} (#{commit['id'][0..6]})\n"
      end
      
      message += "\n... und #{commits.length - 5} weitere Commits" if commits.length > 5
      message
    when 'pull_request'
      pr = payload['pull_request'] || {}
      action = payload['action'] || ''
      number = pr['number'] || ''
      title = pr['title'] || ''
      user = pr.dig('user', 'login') || 'Unknown'
      
      "GitHub Pull Request Event\n" +
      "Action: #{action}\n" +
      "PR ##{number}: #{title}\n" +
      "Von: #{user}"
    else
      "GitHub Event: #{event_type}\n" +
      "Details: #{payload.to_json}"
    end
  end
end

