class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
    @chats = current_user.chats.includes(:recipients)
  end

  def new
    @chat = Chat.new
  end

  def start
    chat_ids = current_user.chats.map(&:id)
    chat_with_user = Chat.includes(:chat_recipients).where( id: chat_ids, chat_recipients: { user_id: params[:user] } ).first
    redirect_to chat_path(chat_with_user.id) and return if chat_with_user.present?
    new_chat = Chat.create!
    new_chat.chat_recipients.create!(user_id: current_user.id)
    new_chat.chat_recipients.create!(user_id: params[:user_id])
    redirect_to chat_path(new_chat)
  end

  def show
    @chat = current_user.chats.includes(:recipients).find(params[:id])
    current_user.seen_on_chat(@chat.id)
    @messages = @chat.messages.includes(:user).order(created_at: :desc).limit(5).reverse
    @message = Message.new
    @recipients = @chat.recipients
  end

  def load_more
    @chat = Chat.find(params[:id])
    @messages = @chat.messages.order(created_at: :desc).limit(5).offset(params[:page].to_i * 5)
  end

  def create
    @chat = current_user.chats.build(chat_params)
    if @chat.save
      flash[:success] = 'Chat added!'
      redirect_to chats_path
    else
      render 'new'
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:title)
  end
end
