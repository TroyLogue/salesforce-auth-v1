require_relative '../../../shared_components/base_page'

class UserSettings < BasePage
  SETTINGS_DIV = { css: '#user-settings-tabs' }
  NEW_PASSWORD_INPUT = { css: '#password' }
  CONFIRM_NEW_PASSWORD = { css: '#password-confirmation' }
  SUBMIT_BUTTON = { css: '#user-settings-tabs > div.ui-base-card.ui-base-card--bordered > div.ui-gradient > div > div:nth-child(4) > div > div > div:nth-child(1) > form > div.row > div > div > button' } # to do - add id to this button

  def page_displayed?
    is_displayed?(SETTINGS_DIV) &&

      # page lands on 'Account Information' tab
      # so these should be displayed
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
