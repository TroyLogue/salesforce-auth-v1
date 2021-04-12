require_relative '../../../shared_components/base_page'

class LoginEmailEhr < BasePage
  AUTH_FORM = { css: '#auth-form-container' }.freeze
  EMAIL_INPUT = { css: '#user_email' }.freeze
  ERROR_MESSAGE = { xpath: '//*[@id="new_app_5_user"]/div[5]/p' }.freeze
  INCORRECT_MESSAGE = 'Sorry, this email or password is incorrect.'.freeze
  INVALID_EMAIL_TEXT = 'Please enter a valid email address.'.freeze
  INVALID_FEEDBACK = { css: '.invalid-feedback' }.freeze
  ALERT_DIV = { css: '.flash_notice' }.freeze
  NEXT_BUTTON = { css: 'input[value="Next"]' }.freeze
  NEW_USER_FORM = { css: '#new_user' }.freeze
  LOGOUT_SUCCESS_TEXT = 'Signed out successfully.'.freeze

  def check_error_message(message)
    text(ERROR_MESSAGE).include?(message)
  end

  def invalid_email_message_displayed?
    text(INVALID_FEEDBACK).include?(INVALID_EMAIL_TEXT)
  end

  def signed_out_message_displayed?
    is_displayed?(ALERT_DIV) &&
      text_include?(LOGOUT_SUCCESS_TEXT, ALERT_DIV)
  end

  def page_displayed?
    is_displayed?(NEW_USER_FORM)
  end

  def submit(address)
    enter(address, EMAIL_INPUT)
    click(NEXT_BUTTON)
  end

  def incorrect_error_displayed?
    check_error_message(INCORRECT_MESSAGE)
  end

end
