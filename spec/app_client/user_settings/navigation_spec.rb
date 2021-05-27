# frozen_string_literal: true

require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative './pages/account_info_page'
require_relative './pages/navigation'
require_relative './pages/notification_prefs_page'

describe '[User Settings Navigation]', :user_settings, :app_client do
  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:user_settings_account_info_page) { UserSettings::AccountInfoPage.new(@driver) }
  let(:user_settings_navigation) { UserSettings::Navigation.new(@driver) }
  let(:user_settings_notification_prefs_page) { UserSettings::NotificationPrefsPage.new(@driver) }

  context('[As a user]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::SETTINGS_USER)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'Navigate my settings', :uuqa_319 do
      user_menu.go_to_user_settings
      user_settings_navigation.go_to_notifications_tab
      expect(user_settings_notification_prefs_page.page_displayed?).to be_truthy
      user_settings_navigation.go_to_account_info_tab
      expect(user_settings_account_info_page.page_displayed?).to be_truthy
    end
  end
end
