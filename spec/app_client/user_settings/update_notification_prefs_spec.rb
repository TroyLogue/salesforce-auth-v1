# frozen_string_literal: true

require_relative '../root/pages/notifications'
require_relative './pages/notification_prefs_page'

describe '[User Settings - Update Notification Preferences]', :user_settings, :app_client do
  let(:notifications) { Notifications.new(@driver) }
  let(:user_settings_notification_prefs_page) { UserSettings::NotificationPrefsPage.new(@driver) }

  # this test case was added when Ivy League users got errors while trying to load notification preferences
  context('[As a user with network notification preferences]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_01_USER)
      user_settings_notification_prefs_page.authenticate_and_navigate_to(token: @auth_token,
                                                                         path: UserSettings::NotificationPrefsPage::PATH)
    end

    it 'loads network notification preferences correctly without error messages', :uuqa_1613 do
      expect(notifications.is_displayed?(Notifications::ERROR_BANNER)).to be false
      expect(user_settings_notification_prefs_page.page_displayed?).to be_truthy
    end
  end

  context('[As a user]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::SETTINGS_USER)
      user_settings_notification_prefs_page.authenticate_and_navigate_to(token: @auth_token,
                                                                         path: UserSettings::NotificationPrefsPage::PATH)
    end

    it 'updates provider assistance request preference', :uuqa_1613 do
      expect(notifications.is_displayed?(Notifications::ERROR_BANNER)).to be false
      expect(user_settings_notification_prefs_page.page_displayed?).to be_truthy

      checkbox_value = user_settings_notification_prefs_page.assistance_request_received_checkbox_value
      user_settings_notification_prefs_page.click_assistance_request_received_toggle

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::USER_UPDATED)

      if checkbox_value == 'true'
        expect(user_settings_notification_prefs_page.assistance_request_received_checkbox_value).to eq nil
      end
      if checkbox_value.nil?
        expect(user_settings_notification_prefs_page.assistance_request_received_checkbox_value).to eq 'true'
      end
    end
  end
end
