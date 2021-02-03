# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'
require_relative './pages/notification_prefs_page'

describe '[User Settings - Update Notification Preferences]', :user_settings, :app_client do
  include Login

  let(:home_page) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:user_settings_notification_prefs_page) { UserSettings::NotificationPrefsPage.new(@driver) }

  # this test case was added when Ivy League users got errors while trying to load notification preferences
  context('[As a user with network notification preferences]') do
    before do
      log_in_as(Login::CC_HARVARD)
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'loads network notification preferences correctly without error messages', :uu3_51250, :core_382 do
      user_settings_notification_prefs_page.load_page
      expect(notifications.error_notification_not_displayed?).to be_truthy
      expect(user_settings_notification_prefs_page.page_displayed?).to be_truthy
    end
  end

  context('[As a user]') do
    before do
      log_in_as(Login::SETTINGS_USER)
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'updates provider assistance request preference', :uuqa_1613 do
      user_settings_notification_prefs_page.load_page
      expect(notifications.error_notification_not_displayed?).to be_truthy
      expect(user_settings_notification_prefs_page.page_displayed?).to be_truthy

      checkbox_value = user_settings_notification_prefs_page.assistance_request_received_checkbox_value
      user_settings_notification_prefs_page.click_assistance_request_received_toggle

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::SETTINGS_UPDATED)

      if checkbox_value == 'true'
        expect(user_settings_notification_prefs_page.assistance_request_received_checkbox_value).to eq nil
      end
      if checkbox_value.nil?
        expect(user_settings_notification_prefs_page.assistance_request_received_checkbox_value).to eq 'true'
      end
    end
  end
end
