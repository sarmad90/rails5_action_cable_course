class ChatRecipient < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :chat
  # Associations

  # Scopes
  scope :for_user, -> (user_id) {
      where(user_id: user_id)
    }
  # Scopes

  alias_method :seen, :touch
end
