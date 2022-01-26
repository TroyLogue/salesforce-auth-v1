# https://uniteus4.my.salesforce.com
require_relative '../../shared_components/base_page'

require 'date'

class SalesforceVerificationPage < BasePage

CODE_FIELD = {css: '#emc'}
VERIFY_BUTTON = {css: '#save'}

def enter_code
  clear_then_enter('764237', CODE_FIELD)
end

def click_login
  click(VERIFY_BUTTON)
end

def verification_page_display?
  check_displayed?(CODE_FIELD)
end

def verification_error_text?
    'Invalid or expired verification code. Try again.'
end

def invalid_code_error_message
  "You have entered invalid verification CODE!."
end

end
