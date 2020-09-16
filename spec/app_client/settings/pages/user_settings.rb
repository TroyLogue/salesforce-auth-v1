require_relative '../../../shared_components/base_page'

class UserSettings < BasePage
  SETTINGS_DIV = { css: '#user-settings-tabs' }
  NEW_PASSWORD_INPUT = { css: '#password' }
  CONFIRM_NEW_PASSWORD = { css: '#password-confirmation' }
  SUBMIT_BUTTON = { css: '#user-settings-tabs > div.ui-base-card.ui-base-card--bordered > div.ui-gradient > div > div:nth-child(4) > div > div > div:nth-child(1) > form > div.row > div > div > button' } # to do - add id to this button
  NOTIFICATIONS_PREFERENCES = { css: '.notification-preferences__content' }
  TWO_FACTOR_AUTH_BTN = { css: '#enable-2fa-btn'}
  NEW_PASSWORD_BOX = { css: '#password'}
  ACCOUNT_INFO_TAB = { css: '#user-profile-tab' }
  NOTIFICATIONS_TAB = { css: '#user-notifications-tab' }

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

  #Is account information page displayed
  def account_page_displayed?
    is_displayed?(TWO_FACTOR_AUTH_BTN)
    is_displayed?(NEW_PASSWORD_BOX)
  end

  #Is notifications page displayed
  def notifications_page_displayed?
    is_displayed?(NOTIFICATIONS_PREFERENCES)
  end

  def go_to_notifications_tab
    click(NOTIFICATIONS_TAB)
  end

  def go_to_account_info_tab
      click(ACCOUNT_INFO_TAB)
  end
end
