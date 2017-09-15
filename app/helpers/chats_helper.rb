module ChatsHelper
  def back_link
    link_to_chats = link_to raw('<i class="fa fa-arrow-left" aria-hidden="true"></i>&nbsp; Chats'), chats_path, class: 'btn btn-default'
    return link_to_chats if request.referrer.nil?
    if request.referrer.include?('/chats')
      link_to raw('<i class="fa fa-arrow-left" aria-hidden="true"></i>&nbsp; Chats'), :back, class: 'btn btn-default'
    else
      link_to_chats
    end
  end

  def typing_users(participants)
    if participants.size > 1
      participants.first(3).to_sentence + ' are typing...'
    else
      participants.first + ' is typing...'
    end
  end
end
