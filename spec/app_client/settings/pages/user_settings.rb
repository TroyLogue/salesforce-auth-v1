require_relative '../../../shared_components/base_page'

class UserSettings < BasePage
  ACCOUNT_INFO_TAB = { css: '#user-profile-tab' }
  NOTIFICATIONS_TAB = { css: '#user-notifications-tab' }
  NOTIFICATIONS_PREFERENCES = { css: '.notification-preferences__content' }
  RESET_PW_LINK = { css: '.reset-pw-link' }
  SETTINGS_DIV = { css: '#user-settings-tabs' }
  TWO_FACTOR_AUTH_BTN = { css: '#enable-2fa-btn'}

  def page_displayed?
    is_displayed?(SETTINGS_DIV) &&
    is_displayed?(TWO_FACTOR_AUTH_BTN) &&
    is_displayed?(RESET_PW_LINK)
  end

  def click_reset_pw
    click(RESET_PW_LINK)
  end

  #Is account information page displayed
  def account_page_displayed?
    is_displayed?(TWO_FACTOR_AUTH_BTN)
    is_displayed?(RESET_PW_LINK)
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
