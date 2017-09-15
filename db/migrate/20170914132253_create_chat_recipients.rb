class CreateChatRecipients < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_recipients do |t|
      t.references :user, foreign_key: true
      t.references :chat, foreign_key: true

      t.timestamps
    end
  end
end
