class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Associations
  has_many :chat_recipients, dependent: :destroy, inverse_of: 'user'
  has_many :chats, through: :chat_recipients
  has_many :messages, dependent: :destroy, inverse_of: 'user'
  # Associations

  # Class Methods
  def self.other_recipients(user_id)
    where.not(id: user_id)
  end
  # Class Methods

  # Instance Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def has_subscribed(chat_id)
    other_people_status = check_other_people_statuses(chat_id) # Checking other participants statuses
    redis.set("user_#{id}_online", '1')
    ActionCable.server.broadcast("chat_#{chat_id}_channel",
      user_id: id,
      email: email,
      online: true,
      other_participants_online: other_people_status
    )
    redis.quit
  end

  def has_unsubscribed(chat_id)
    other_people_status = check_other_people_statuses(chat_id) # Checking other participants statuses
    redis.del("user_#{id}_online")
    ActionCable.server.broadcast("chat_#{chat_id}_channel",
      user_id: id,
      email: email,
      online: false,
      other_participants_online: other_people_status
    )
    redis.quit
  end

  def online?
    result = redis.get("person_#{id}_online")
    redis.quit
    result ? true : false
  end

  def seen_on_chat(chat_id = nil, chat = nil)
    fail ArgumentError, 'A valid chat_id or chat instance must be provided' if chat_id.blank? && chat.blank?
    if chat
      chat.chat_recipients.for_user(id).first.seen # can be refactored by the law of delimiter
    else
      chat = Chat.includes(:chat_recipients).find(chat_id)
      chat.chat_recipients.for_user(id).first.seen
    end
    nil # return nothing
  end
  # Instance Methods

  private
    def check_other_people_statuses(chat_id)
      other_recipients = Chat.find(chat_id).recipients.other_recipients(id)
      other_people_status = Hash.new{ |k, v| k[v] = nil }
      other_recipients.map { |other_user| other_people_status[other_user.id] = other_user.online? }
      other_people_status
    end

    def redis; Redis.new; end
end
