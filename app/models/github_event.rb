class GithubEvent < ActiveRecord::Base
  belongs_to :github_webhook

  validates :event_type, presence: true
  validates :payload, presence: true

  # Payload wird als JSON-String gespeichert und beim Zugriff geparst
  def payload_hash
    @payload_hash ||= begin
      case payload
      when Hash
        payload
      when String
        JSON.parse(payload)
      else
        JSON.parse(payload.to_s)
      end
    rescue JSON::ParserError
      {}
    end
  end

  def payload=(value)
    @payload_hash = nil
    super(value.is_a?(String) ? value : value.to_json)
  end

  def formatted_message
    hash = payload_hash
    
    case event_type
    when 'push'
      commits = hash['commits'] || []
      ref = hash['ref'] || ''
      branch = ref.gsub('refs/heads/', '')
      "Push zu Branch '#{branch}': #{commits.length} Commit(s)"
    when 'pull_request'
      action = hash['action'] || ''
      pr_number = hash.dig('pull_request', 'number') || ''
      "Pull Request ##{pr_number}: #{action}"
    else
      "Event: #{event_type}"
    end
  end
end

