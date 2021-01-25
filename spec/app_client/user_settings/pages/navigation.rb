# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

module UserSettings
  class Navigation < BasePage
    ACCOUNT_INFO_TAB = { css: '#user-profile-tab' }.freeze
    NOTIFICATIONS_TAB = { css: '#user-notifications-tab' }.freeze

    def go_to_notifications_tab
      click(NOTIFICATIONS_TAB)
    end

    def go_to_account_info_tab
      click(ACCOUNT_INFO_TAB)
    end
  end
end
