class Chat < ApplicationRecord
  # # Constants
  # EVENTS = { subscribed: "subscribed", unsubscribed: "unsubscribed" }
  # # Constants

  # Associations
  has_many :chat_recipients, dependent: :destroy, inverse_of: 'chat'
  has_many :recipients, through: :chat_recipients, source: :user
  has_many :messages, dependent: :destroy, inverse_of: 'chat'
  # Associations

  # Instance methods
  def joined_recipients_names
    recipients.map(&:email).to_sentence
  end
  # Instance methods
end
