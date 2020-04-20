require 'http' 
require 'json' 
 
module MailtrapHelper

  STAGING_ID = '99406' 
  API_TOKEN = '6b245be8870dcd04019455d0a918421b'
  PASSWORD_RESET_SUBJECT = "Reset password instructions"

  def get_messages(mailbox_id: STAGING_ID) 
    response = HTTP.get("https://mailtrap.io/api/v1/inboxes/#{mailbox_id}/messages", 
                        :params => {:api_token => API_TOKEN})
    if response.status.success? 
      messages = JSON.parse(response.body)
    else 
      raise StandardError.new "Call to mailtrap API failed"
    end
    return messages
  end

  def get_html_of_first_message 
    message_id = get_first_message_id
    get_html_of_message(message_id: message_id)
  end

  def get_html_of_message(message_id:, mailbox_id: STAGING_ID)
    HTTP.headers(:api-token, API_TOKEN)
      .get("https://mailtrap.io/api/v1/inboxes/#{mailbox_id}/messages/#{message_id}/body.html")
      .body
  end

  def get_first_message
    get_messages[0]
  end

  def get_first_message_id
    get_first_message.id
  end 

  def is_password_reset_email?(message)
    message["subject"] == PASSWORD_RESET_SUBJECT  
  end

  def message_sent_to(message)
    message["to_email"]
  end

end
