require_relative '../../../shared_components/base_page'

class LoginEmail < BasePage

  COVER_IMAGE = { css: '.cover-image' }

  AUTH_FORM = { css: '#auth-form-container' }
  EMAIL_INPUT = { css: '#user_email' }
  NEXT_BUTTON = { css: 'input[value="Next"]' }

  PASSWORD_RESET_DIV = { css: "#new_user > div:nth-child(3)" }
  PASSWORD_RESET_TEXT = 'If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.'

  def page_displayed?
    is_displayed?(AUTH_FORM) &&
    is_displayed?(EMAIL_INPUT)
  end

  def password_reset_message_displayed?
    is_displayed?(PASSWORD_RESET_DIV) &&
      text_include?(PASSWORD_RESET_TEXT, PASSWORD_RESET_DIV)
  end

  def submit(address)
    click(EMAIL_INPUT)
    enter(address, EMAIL_INPUT)
    click(NEXT_BUTTON)
  end

end
