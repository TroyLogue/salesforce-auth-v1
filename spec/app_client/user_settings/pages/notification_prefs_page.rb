# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

module UserSettings
  class NotificationPrefsPage < BasePage
    NOTIFICATIONS_ENABLED_TOGGLE = { name: 'email_updates_enabled' }.freeze
    NOTIFICATIONS_PREFERENCES_CONTENT = { css: '.notification-preferences__content' }.freeze

    # Global notifs
    AR_RECEIVED_TOGGLE = { name: 'new_assistance_request' }.freeze

    PATH = '/user/settings/notifications'

    def page_displayed?
      enable_notifications_if_disabled

      is_displayed?(NOTIFICATIONS_PREFERENCES_CONTENT)
    end

    def assistance_request_received_checkbox_value
      checkbox_value(AR_RECEIVED_TOGGLE)
    end

    def click_assistance_request_received_toggle
      click(AR_RECEIVED_TOGGLE)
    end

    private

    def enable_notifications_if_disabled
      click(NOTIFICATIONS_ENABLED_TOGGLE) if notifications_enabled_value.nil?
    end

    def disble_notifications_if_enabled
      click(NOTIFICATIONS_ENABLED_TOGGLE) if notifications_enabled_value == 'true'
    end

    def notifications_enabled_value
      checkbox_value(NOTIFICATIONS_ENABLED_TOGGLE)
    end
  end
end
