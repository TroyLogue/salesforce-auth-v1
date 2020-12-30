require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'
require_relative '../root/pages/right_nav'
require_relative '../user_settings/pages/account_info_page'
require_relative '../user_settings/pages/change_password_page'
require_relative '../user_settings/pages/security_settings_page'

describe '[User Settings - Change Password]', :app_client, :user_settings, order: :defined do
  include Login

  let(:account_info_page) { UserSettings::AccountInfoPage.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:change_password_page) { UserSettings::ChangePasswordPage.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:security_settings_page) { UserSettings::SecuritySettingsPage.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }

  context('[as licensed user] From user settings page,') do
    let(:reset_user) { Login::RESET_PW_USER }
    let(:original_pw) { Login::DEFAULT_PASSWORD }
    let(:insecure_pw) { Login::INSECURE_PASSWORD }
    let(:new_pw) { 'Uniteus123' }

    it 'cancels password change while logged in', :uuqa_1493 do
      log_in_as(reset_user)
      expect(home_page.page_displayed?).to be_truthy # checking for a successful login
      user_menu.go_to_user_settings
      expect(account_info_page.page_displayed?).to be_truthy

      account_info_page.click_edit_security_settings
      expect(security_settings_page.page_displayed?).to be_truthy

      security_settings_page.click_change_pw
      expect(change_password_page.page_displayed?).to be_truthy

      change_password_page.cancel_password_reset
      # should be back on the security settings page:
      expect(security_settings_page.page_displayed?).to be_truthy
    end

    it 'cannot change password to an insecure password', :uuqa_803 do
      log_in_as(reset_user)
      expect(home_page.page_displayed?).to be_truthy # checking for a successful login
      user_menu.go_to_user_settings
      expect(account_info_page.page_displayed?).to be_truthy

      account_info_page.click_edit_security_settings
      expect(security_settings_page.page_displayed?).to be_truthy

      security_settings_page.click_change_pw
      expect(change_password_page.page_displayed?).to be_truthy

      change_password_page.change_password(current_pw: original_pw, new_pw: insecure_pw)
      expect(change_password_page.insecure_pw_message_displayed?).to be_truthy
    end

    it 'can change password to a secure password', :uuqa_247 do
      log_in_as(reset_user)
      expect(home_page.page_displayed?).to be_truthy # checking for a successful login
      user_menu.go_to_user_settings
      expect(account_info_page.page_displayed?).to be_truthy

      account_info_page.click_edit_security_settings
      expect(security_settings_page.page_displayed?).to be_truthy

      security_settings_page.click_change_pw
      expect(change_password_page.page_displayed?).to be_truthy

      change_password_page.change_password(current_pw: original_pw, new_pw: new_pw)

      # verify success:
      expect(login_email.page_displayed?).to be_truthy
      expect(login_email.password_updated_message_displayed?).to be_truthy
    end

    # TODO: - convert to API call for cleanup and remove :order => :defined tag
    it 'changes password back to default password', :uuqa_247 do
      log_in_as(reset_user, new_pw)
      expect(home_page.page_displayed?).to be_truthy # checking for a successful login
      user_menu.go_to_user_settings

      account_info_page.click_edit_security_settings
      expect(security_settings_page.page_displayed?).to be_truthy

      security_settings_page.click_change_pw
      expect(change_password_page.page_displayed?).to be_truthy

      change_password_page.change_password(current_pw: new_pw, new_pw: original_pw)

      # verify success:
      expect(login_email.page_displayed?).to be_truthy
      expect(login_email.password_updated_message_displayed?).to be_truthy
    end
  end
end
