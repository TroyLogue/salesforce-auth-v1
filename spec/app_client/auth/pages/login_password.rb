# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class LoginPassword < BasePage
  FORGOT_PASSWORD_LINK = { css: '#forgot-password-link' }.freeze
  INVALID_ALERT = { css: 'div.flash_alert-container:nth-child(5) > p.flash_alert' }.freeze
  INVALID_TEXT = 'Invalid Email or password.'.freeze
  EDIT_EMAIL_LINK = { css: '#not-you-link' }.freeze
  PASSWORD_INPUT = { css: 'input[id$=user_password]' }.freeze
  SUBMIT_BUTTON = { css: 'input[value="Sign in"]' }.freeze
  USER_EMAIL = { css: '#user-email' }.freeze

  # string to pass to enter_via_js which uses getElementById
  PASSWORD_INPUT_ID = 'input[id$=user_password]'.freeze

  def click_forgot_password
    click_via_js(FORGOT_PASSWORD_LINK)
  end

  def invalid_alert_displayed?
    is_displayed?(INVALID_ALERT)
  end

  def invalid_alert_text
    find(INVALID_ALERT)
    text(INVALID_ALERT)
  end

  def page_displayed?
    is_displayed?(FORGOT_PASSWORD_LINK) &&
      is_displayed?(EDIT_EMAIL_LINK) &&
      is_displayed?(USER_EMAIL) &&
      is_displayed?(PASSWORD_INPUT)
  end

  def submit(password)
    find(PASSWORD_INPUT)

    # js scripts are used with the dynamic login form to avoid race conditions
    enter_via_js(password, PASSWORD_INPUT_ID)
    click_via_js(SUBMIT_BUTTON)
  end
end
