class Message < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :chat
  # Associations

  # Validations
  validates :body, presence: true, length: { minimum: 1, maximum: 1000 }
  # Validations

  # Instance Methods
  def json_for_client
    { body: body, timestamp: timestamp, email: user.email }.to_json
  end

  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end
  # Instance Methods
end
