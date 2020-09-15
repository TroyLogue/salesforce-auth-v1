require_relative '../../../lib/mailtrap_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/forgot_password'
require_relative '../auth/pages/reset_password'
require_relative '../auth/pages/user_edit_password'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'
require_relative '../root/pages/right_nav'
require_relative '../settings/pages/user_settings'

describe '[Auth - Reset Password]', :app_client, :auth, :order => :defined do
  include Login
  include MailtrapHelper

  let(:base_page) { BasePage.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:forgot_password) { ForgotPassword.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:reset_password) { ResetPassword.new(@driver) }
  let(:user_edit_password) { UserEditPassword.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:user_settings) { UserSettings.new(@driver) }

=begin
  context('[as cc user] From login page,') do
    let(:email) { Login::CC_HARVARD }

    before {
      base_page.get ''
      expect(login_email.page_displayed?).to be_truthy

      login_email.submit(email)
      expect(login_password.page_displayed?).to be_truthy

      login_password.click_forgot_password
      expect(forgot_password.page_displayed?).to be_truthy
      expect(forgot_password.user_email_value).to include(email)
    }

    it 'sends reset password email', :uuqa_11, :uuqa_171 do
      forgot_password.click_to_send_email
      expect(login_password.page_displayed?).to be_truthy
      expect(login_email.password_reset_message_displayed?).to be_truthy

      # verify in mailtrap:
      message = get_first_message
      expect(is_password_reset_email?(message)).to be_truthy
      expect(message_sent_to(message)).to include(email)

      #verify that the link from the email leads to reset pw page
      reset_link = get_first_reset_link
      @driver.get(reset_link)
      expect(reset_password.page_displayed?).to be_truthy
    end

    it 'cancels password reset', :uuqa_12 do
      forgot_password.cancel_password_reset

      expect(login_email.page_displayed?).to be_truthy
    end
  end
=end
  context('[as org user] From user settings page,') do
    let (:reset_user) { Login::RESET_PW_USER }
    let (:original_pw) { Login::DEFAULT_PASSWORD }
    let (:insecure_pw) { Login::INSECURE_PASSWORD }
    let (:new_pw) { 'Uniteus123' }

    it 'cancels password reset while logged in', :uuqa_1493 do
      log_in_as(reset_user)
      expect(home_page.page_displayed?).to be_truthy #checking for a successful login
      user_menu.go_to_user_settings
      expect(user_settings.page_displayed?).to be_truthy

      user_settings.click_reset_pw
      expect(user_edit_password.page_displayed?).to be_truthy

      user_edit_password.cancel_password_reset
      # should be back on the user settings page:
      expect(user_settings.page_displayed?).to be_truthy
    end

    it 'cannot reset password to an insecure password', :uuqa_803 do
      log_in_as(reset_user)
      expect(home_page.page_displayed?).to be_truthy #checking for a successful login
      user_menu.go_to_user_settings
      expect(user_settings.page_displayed?).to be_truthy

      user_settings.click_reset_pw
      expect(user_edit_password.page_displayed?).to be_truthy

      user_edit_password.update_password(original_pw, insecure_pw)
      expect(user_edit_password.page_displayed?).to be_truthy
      expect(user_edit_password.insecure_pw_message_displayed?).to be_truthy
    end

    it 'can reset password to a secure password', :uuqa_247 do
      log_in_as(reset_user)
      expect(home_page.page_displayed?).to be_truthy #checking for a successful login
      user_menu.go_to_user_settings
      expect(user_settings.page_displayed?).to be_truthy

      user_settings.click_reset_pw
      expect(user_edit_password.page_displayed?).to be_truthy

      user_edit_password.update_password(original_pw, new_pw)

      # verify success:
      expect(login_email.page_displayed?).to be_truthy
      expect(login_email.password_updated_message_displayed?).to be_truthy
    end

    #TODO - convert to API call for cleanup and remove :order => :defined tag
    it 'resets password back to default password', :uuqa_247 do
      log_in_as(reset_user, new_pw)
      expect(home_page.page_displayed?).to be_truthy #checking for a successful login
      user_menu.go_to_user_settings
      user_settings.click_reset_pw
      expect(user_edit_password.page_displayed?).to be_truthy

      user_edit_password.update_password(new_pw, original_pw)

      # verify success:
      expect(login_email.page_displayed?).to be_truthy
      expect(login_email.password_updated_message_displayed?).to be_truthy
    end
  end
end
