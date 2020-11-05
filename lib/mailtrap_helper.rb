require 'http'
require 'json'

module MailtrapHelper
  PASSWORD_RESET_SUBJECT = 'Reset password instructions'

  def find_reset_link(str)
    auth_url = ENV['auth_url'].gsub('/', '\/')
    str.match(/#{auth_url}\/secret\/edit\?client_id=\w{10}&amp;reset_password_token=\S{20}/)[0]
  end

  def find_share_link(str)
    base_url = "https://bit.ly".gsub('/', '\/')
    str.match(/#{base_url}\/\w{7}/)[0]
  end

  def get_messages(mailbox_id: ENV['mailtrap_id'])
    response = HTTP.get("https://mailtrap.io/api/v1/inboxes/#{mailbox_id}/messages",
                        :params => { :api_token => ENV['API_TOKEN'] })
    if response.status.success?
      return JSON.parse(response.body)
    else
      raise StandardError.new 'Call to mailtrap API failed with status #{response.status}'
    end
  end

  def get_html_of_first_message
    message_id = get_first_message_id
    get_html_of_message(message_id: message_id)
  end

  def get_html_of_message(message_id:, mailbox_id: ENV['mailtrap_id'])
    response = HTTP.get("https://mailtrap.io/api/v1/inboxes/#{mailbox_id}/messages/#{message_id}/body.html",
                        :params => { :api_token => ENV['API_TOKEN'] })
    if response.status.success?
      return response.body
    else
      raise StandardError.new 'Call to mailtrap API failed with status #{response.status}'
    end
  end

  def get_first_message
    get_messages[0]
  end

  def get_first_message_id
    get_first_message['id']
  end

  def get_first_reset_link
    str = get_html_of_first_message.to_s
    find_reset_link(str)
  end

  def get_share_link(message:)
    html = get_html_of_message(message_id: message['id']).to_s
    find_share_link(html)
  end

  def is_password_reset_email?(message)
    message['subject'] == PASSWORD_RESET_SUBJECT
  end

  def is_share_email?(message:, network_name:, provider_name:)
    @share_subject = "#{network_name} Has Sent You Information About #{provider_name}"
    message['subject'].include?(@share_subject)
  end

  def message_sent_to(message)
    message['to_email']
  end
end
