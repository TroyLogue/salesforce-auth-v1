# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class UserSettingsPage < BasePage
  ACCOUNT_INFO_TAB = { css: '#user-profile-tab' }.freeze
  NOTIFICATIONS_TAB = { css: '#user-notifications-tab' }.freeze
  NOTIFICATIONS_PREFERENCES = { css: '.notification-preferences__content' }.freeze
  RESET_PW_LINK = { css: '.reset-pw-link' }.freeze
  SETTINGS_DIV = { css: '#user-settings-tabs' }.freeze
  TWO_FACTOR_AUTH_BTN = { css: '#enable-2fa-btn' }.freeze

  def page_displayed?
    is_displayed?(SETTINGS_DIV) &&
      is_displayed?(TWO_FACTOR_AUTH_BTN) &&
      is_displayed?(RESET_PW_LINK)
  end

  def click_reset_pw
    click(RESET_PW_LINK)
  end

  # Is account information page displayed
  def account_page_displayed?
    is_displayed?(TWO_FACTOR_AUTH_BTN)
    is_displayed?(RESET_PW_LINK)
  end

  # Is notifications page displayed
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
