require_relative '../../../shared_components/base_page'

class ResetPassword < BasePage
  NEW_PASSWORD_INPUT = { css: '#password-edit-input' }
  CONFIRM_NEW_PASSWORD = { css: '#password-edit-input-confirm' }
  SUBMIT_BUTTON = { css: '#password-edit-submit-btn' }

  def page_displayed?
    is_displayed?(NEW_PASSWORD_INPUT) &&
    is_displayed?(CONFIRM_NEW_PASSWORD) &&
    is_displayed?(SUBMIT_BUTTON)
  end

  def change_password(new_pw)
    enter(new_pw, NEW_PASSWORD_INPUT)
    enter(new_pw, CONFIRM_NEW_PASSWORD)
    click(SUBMIT_BUTTON)
  end
end
