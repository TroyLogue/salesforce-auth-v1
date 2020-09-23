require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/org_settings'
require_relative '../root/pages/home_page'
require_relative './pages/settings_profile_page'
require_relative './pages/settings_programs_page'
require_relative './pages/settings_user_page'
require_relative './pages/user_settings'

describe '[Settings Navigation CC]', :navigation, :settings do
  include Login

  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:org_profile) { Settings::OrganizationProfile.new(@driver) }
  let(:org_tabs) { OrgSettings::OrgTabs.new(@driver) }
  let(:program_table) { Settings::ProgramTable.new(@driver) }
  let(:user_table) { Settings::UserTable.new(@driver) }
  let(:user_settings) { UserSettings.new(@driver) }

  context('[As a cc user]') do
    before {
      log_in_as(Login::CC_HARVARD)
    }

    it 'Navigate through Org Settings Tabs', :uuqa_323, :uuqa_322, :uuqa_321 do
      org_menu.go_to_users_table()
      org_tabs.go_to_profile_tab()
      expect(org_profile.page_displayed?).to be_truthy
      org_tabs.go_to_programs_tab()
      expect(program_table.page_displayed?).to be_truthy
      org_tabs.go_to_users_tab()
      expect(user_table.page_displayed?).to be_truthy
    end

    it 'Navigate user settings', :uuqa_319 do
      user_menu.go_to_user_settings()
      user_settings.go_to_notifications_tab()
      expect(user_settings.notifications_page_displayed?).to be_truthy
      user_settings.go_to_account_info_tab()
      expect(user_settings.account_page_displayed?).to be_truthy
    end
  end
end
