require_relative '../../../shared_components/base_page'

class UserEditPassword < BasePage
  AUTH_FORM_CONTAINER = { css: '#auth-form-container' }
  CURRENT_EMAIL = { css: '.display-email' }
  CURRENT_PASSWORD_INPUT = { css: '#user_current_password' }
  NEW_PASSWORD_INPUT = { css: '#user_password' }
  CONFIRM_NEW_PASSWORD = { css: '#user_password_confirmation' }
  UPDATE_BUTTON = { xpath: "//input[@value='Update']" }
  CANCEL_BUTTON = { css: '.cancel-link' }

  #error messages:
  CURRENT_PW_TEXT = "Current password is invalid"
  INSECURE_PW_TEXT = "Password is not safe to use as it appears in a list of weak passwords. Please change your password to something more secure."


  def page_displayed?
    is_displayed?(CURRENT_EMAIL) &&
    is_displayed?(CURRENT_PASSWORD_INPUT) &&
    is_displayed?(NEW_PASSWORD_INPUT) &&
    is_displayed?(CONFIRM_NEW_PASSWORD) &&
    is_displayed?(UPDATE_BUTTON) &&
    is_displayed?(CANCEL_BUTTON)
  end

  def update_password(current_pw:, new_pw:)
    enter(current_pw, CURRENT_PASSWORD_INPUT)
    enter(new_pw, NEW_PASSWORD_INPUT)
    enter(new_pw, CONFIRM_NEW_PASSWORD)
    click(UPDATE_BUTTON)
  end

  def cancel_password_reset
    click(CANCEL_BUTTON)
  end

  def insecure_pw_message_displayed?
    page_text.include?(INSECURE_PW_TEXT)
  end

  def page_text
    text(AUTH_FORM_CONTAINER)
  end
end
