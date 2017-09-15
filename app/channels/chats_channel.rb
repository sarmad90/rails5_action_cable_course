class ChatsChannel < ApplicationCable::Channel
  include ChatsHelper

  def subscribed
    stream_from "chat_#{params['chat_id']}_channel"
    # UserStatusBroadcastJob.perform_later(current_person, Chat::EVENTS[:subscribed], params['chat_id'])
    current_user.has_subscribed(params['chat_id'])
  end

  def unsubscribed
    current_user.has_unsubscribed(params['chat_id'])
    # UserStatusBroadcastJob.perform_later(current_person, Chat::EVENTS[:unsubscribed], params['chat_id'])
  end

  def send_message(data)
    message = current_user.messages.create!(body: data['message'], chat_id: data['chat_id'])
    ActionCable.server.broadcast("chat_#{message.chat.id}_channel", message:
      { body: message.body, timestamp: message.timestamp, email: current_user.email })
    # MessageBroadcastJob.perform_later(data, current_person)
  end

  def typing(data)
    other_recipients = Chat.find(data['chat_id']).recipients.other_recipients(current_user.id)
    ActionCable.server.broadcast("chat_#{data['chat_id']}_channel",
       typing_participants: {
           emails: other_recipients.map(&:email),
           current_participant_email: current_user.email,
           typing: typing_users(other_recipients.map(&:email))
       }
    )
  end
end
