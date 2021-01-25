require_relative '../../../shared_components/base_page'

class LoginEmailEhr < BasePage
  AUTH_FORM = { css: '#auth-form-container' }
  EMAIL_INPUT = { css: '#user_email' }
  ERROR_MESSAGE = { xpath: '//*[@id="new_app_5_user"]/div[5]/p' }
  INCORRECT_MESSAGE = "Sorry, this email or password is incorrect."
  INVALID_EMAIL_TEXT = "Please enter a valid email address."
  INVALID_FEEDBACK = { css: '.invalid-feedback' }
  NEXT_BUTTON = { css: 'input[value="Next"]' }
  NEW_USER_FORM = { css: '#new_user' }

  def check_error_message(message)
    text(ERROR_MESSAGE).include?(message)
  end

  def invalid_email_message_displayed?
    text(INVALID_FEEDBACK).include?(INVALID_EMAIL_TEXT)
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
