require_relative '../../../shared_components/base_page'

class LoginEmail < BasePage
  COVER_IMAGE = { css: '.cover-image' }.freeze

  AUTH_FORM = { css: '#auth-form-container' }.freeze
  NEW_USER_FORM = { css: '#new_user' }.freeze
  EMAIL_INPUT = { css: '#user_email' }.freeze
  NEXT_BUTTON = { css: 'input[value="Next"]' }.freeze
  ALERT_DIV = { css: '.flash_notice' }.freeze
  PASSWORD_RESET_TEXT = 'If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.'.freeze
  PASSWORD_UPDATED_TEXT = 'New password set. You can now sign in with your new password.'.freeze
  LOGOUT_SUCCESS_TEXT = 'Signed out successfully.'.freeze

  def page_displayed?
    is_displayed?(NEW_USER_FORM)
  end

  def password_reset_message_displayed?
    is_displayed?(ALERT_DIV) &&
      text_include?(PASSWORD_RESET_TEXT, ALERT_DIV)
  end

  def signed_out_message_displayed?
    is_displayed?(ALERT_DIV) &&
      text_include?(LOGOUT_SUCCESS_TEXT, ALERT_DIV)
  end

  def password_updated_message_displayed?
    text(AUTH_FORM).include?(PASSWORD_UPDATED_TEXT)
  end

  def submit(address)
    enter(address, EMAIL_INPUT)
    click(NEXT_BUTTON)
  end
end
