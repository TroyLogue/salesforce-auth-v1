# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative './pages/user_settings_page'

describe '[User Settings Navigation]', :user_settings, :app_client do
  include Login

  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:user_settings_page) { UserSettingsPage.new(@driver) }

  context('[As a user]') do
    before do
      log_in_as(Login::CC_HARVARD)
    end

    it 'Navigate my settings', :uuqa_319 do
      user_menu.go_to_user_settings
      user_settings_page.go_to_notifications_tab
      expect(user_settings_page.notifications_page_displayed?).to be_truthy
      user_settings_page.go_to_account_info_tab
      expect(user_settings_page.account_page_displayed?).to be_truthy
    end
  end
end
