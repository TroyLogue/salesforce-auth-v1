# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

module UserSettings
  class SecuritySettingsPage < BasePage
    AUTH_FORM = { id: 'auth-form-container' }.freeze
    CHANGE_PW_LINK = { css: 'a[href="/users/edit"]' }.freeze
    TWO_FACTOR_AUTH_ENABLE_LINK = { css: 'a[href="/users/two_factor_registration/new"]' }.freeze
    USER_SETTINGS_LINK = { css: 'a[href$="/user/settings"]' }.freeze

    def load_page
      get_auth('/users/security-settings')
    end

    def page_displayed?
      is_displayed?(AUTH_FORM) &&
        is_displayed?(CHANGE_PW_LINK) &&
        is_displayed?(USER_SETTINGS_LINK)
    end

    def click_return_to_user_settings
      click(USER_SETTINGS_LINK)
    end

    def click_change_pw
      click(CHANGE_PW_LINK)
    end

    def click_two_factor_auth
      click(TWO_FACTOR_AUTH_ENABLE_LINK)
    end

    def turn_on_two_factor_auth_link_displayed?
      is_displayed?(TWO_FACTOR_AUTH_ENABLE_LINK)
    end
  end
end
