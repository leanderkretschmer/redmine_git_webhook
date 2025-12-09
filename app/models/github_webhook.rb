class GithubWebhook < ActiveRecord::Base
  belongs_to :issue
  has_many :github_events, dependent: :destroy

  validates :issue_id, presence: true, uniqueness: true
  validates :secret, presence: true

  before_create :generate_secret

  def webhook_url
    "#{Setting.protocol}://#{Setting.host_name}/github_webhooks/#{id}/receive"
  end

  def content_type
    'application/json'
  end

  private

  def generate_secret
    self.secret ||= SecureRandom.hex(32)
  end
end

