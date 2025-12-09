class GithubEvent < ActiveRecord::Base
  belongs_to :github_webhook

  validates :event_type, presence: true
  validates :payload, presence: true

  serialize :payload, Hash

  before_save :ensure_payload_is_hash

  def formatted_message
    payload_hash = payload.is_a?(Hash) ? payload : JSON.parse(payload)
    
    case event_type
    when 'push'
      commits = payload_hash['commits'] || []
      ref = payload_hash['ref'] || ''
      branch = ref.gsub('refs/heads/', '')
      "Push zu Branch '#{branch}': #{commits.length} Commit(s)"
    when 'pull_request'
      action = payload_hash['action'] || ''
      pr_number = payload_hash.dig('pull_request', 'number') || ''
      "Pull Request ##{pr_number}: #{action}"
    else
      "Event: #{event_type}"
    end
  end

  private

  def ensure_payload_is_hash
    self.payload = JSON.parse(payload) if payload.is_a?(String)
  rescue JSON::ParserError
    # Falls Parsing fehlschlägt, bleibt es wie es ist
  end
end

