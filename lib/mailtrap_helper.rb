require 'http'
require 'json'

module MailtrapHelper
  PASSWORD_RESET_SUBJECT = 'Reset password instructions'
  RESET_PASSWORD_REQUEST_SUBJECT = 'Password Reset Request'
  UNABLE_TO_RESET_PASSWORD_VIA_EMAIL_MESSAGE = 'This is a managed account, so we are unable to complete this request.'

  def body(message)
    get_html_of_message(message_id: message['id']);
  end

  def find_reset_link(str)
    auth_url = ENV['AUTH_URL'].gsub('/', '\/')
    str.match(/#{auth_url}\/secret\/edit\?client_id=\w{10}&amp;reset_password_token=\S{20}/)[0]
  end

  def find_share_link(str)
    base_url = "https://bit.ly".gsub('/', '\/')
    str.match(/#{base_url}\/\w{7}/)[0]
  end

  def get_messages(filter: '', mailbox_id: ENV['MAILTRAP_ID'])
    # Search returns only messages where subject line STARTS WITH filter text
    response = HTTP.get("https://mailtrap.io/api/v1/inboxes/#{mailbox_id}/messages?search=#{filter}",
                        :params => { :api_token => ENV['API_TOKEN'] })
    if response.status.success?
      return JSON.parse(response.body)
    else
      raise StandardError.new "Call to mailtrap API failed with status #{response.status}"
    end
  end

  def get_html_of_first_message
    message_id = get_first_message_id
    get_html_of_message(message_id: message_id)
  end

  def get_html_of_message(message_id:, mailbox_id: ENV['MAILTRAP_ID'])
    response = HTTP.get("https://mailtrap.io/api/v1/inboxes/#{mailbox_id}/messages/#{message_id}/body.html",
                        :params => { :api_token => ENV['API_TOKEN'] })
    if response.status.success?
      return response.body.to_s
    else
      raise StandardError.new "Call to mailtrap API failed with status #{response.status}"
    end
  end

  def get_first_message(filter: '')
    get_messages(filter: filter)[0]
  end

  def get_first_message_id(filter: '')
    get_first_message(filter: filter)['id']
  end

  def get_first_reset_link
    str = get_html_of_first_message
    find_reset_link(str)
  end

  def get_first_password_reset_email
    get_first_message(filter: PASSWORD_RESET_SUBJECT)
  end

  def get_first_reset_password_request_email
    get_first_message(filter: RESET_PASSWORD_REQUEST_SUBJECT)
  end

  def get_first_share_email(network:, provider: '')
    share_subject = "#{network} Has Sent You Information About #{provider}"
    get_first_message(filter: share_subject)
  end

  def get_share_link(message:)
    html = get_html_of_message(message_id: message['id']).to_s
    find_share_link(html)
  end

  def is_password_reset_email?(message)
    message['subject'] == PASSWORD_RESET_SUBJECT
  end

  def is_manual_password_reset_email?(message)
    get_html_of_message(message_id: message['id']).include?(UNABLE_TO_RESET_PASSWORD_VIA_EMAIL_MESSAGE)
  end

  def is_share_email?(message:, network:, provider:)
    @share_subject = "#{network} Has Sent You Information About #{provider}"
    message['subject'].include?(@share_subject)
  end

  def message_sent_to(message)
    message['to_email']
  end
end
