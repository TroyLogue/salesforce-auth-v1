require_relative '../../../shared_components/base_page'

class ForgotPassword < BasePage
  CANCEL_FORGOT_PASSWORD_LINK = { css: '#password-reset-cancel' }
  USER_EMAIL = { css: '#app_2_user_email' }
  SUBMIT_BUTTON = { css: '#password-reset-submit-btn' }

  def cancel_password_reset
    click_via_js(CANCEL_FORGOT_PASSWORD_LINK)
  end

  def user_email_value
    find(USER_EMAIL).attribute('value')
  end

  def page_displayed? 
    wait_for { is_displayed?(SUBMIT_BUTTON) }
    is_displayed?(CANCEL_FORGOT_PASSWORD_LINK)
  end 

  def click_to_send_email
    click(SUBMIT_BUTTON)
  end

end
