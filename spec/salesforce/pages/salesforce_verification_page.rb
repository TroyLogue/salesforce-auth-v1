# frozen_string_literal: true

# https://uniteus4.my.salesforce.com

require_relative '../../shared_components/base_page'
require_relative '../../../lib/mailtrap_helper'


require 'date'
require 'easy_poller'


class SalesforceVerificationPage < BasePage
  # include MailtrapHelper

  CODE_FIELD = { css: '#emc' }.freeze
  VERIFY_BUTTON = { css: '#save' }.freeze
  VERIFICATION_REMEMBER_ME = { css: '#rememberUn' }.freeze

  def click_login
    click(VERIFY_BUTTON)
  end

  def verification_page_display?
    check_displayed?(CODE_FIELD)
  end

  def verification_error_text?
    'Invalid or expired verification code. Try again.'
  end

  def check_verification_remember_me
    click(VERIFICATION_REMEMBER_ME) unless is_checked?(VERIFICATION_REMEMBER_ME)
  end

  def retrieve_code
    wait_controller = MailSlurpClient::WaitForControllerApi.new
    email = wait_controller.wait_for_latest_email({ inbox_id: '8a102a6e-891a-4e7e-9552-08c90af50273',
                                                    unread_only: true, timeout: 10_000 })


    # verify email contents
    puts 'Test passed!!' if (email.subject) == 'Test'
  end

  def select_code_field
    click(CODE_FIELD)
  end

  def enter_code
    ver_code = retrieve_code
    clear_then_enter(ver_code.to_s, CODE_FIELD)
  end

  def code_present?
    if CODE_FIELD.empty? || CODE_FIELD.nil?
      CODE_FIELD.select
    end
    sleep 30
    click_login
  end
end


