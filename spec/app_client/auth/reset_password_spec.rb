require_relative '../../spec_helper'
require_relative '../../../lib/mailtrap_helper' 
require_relative '../auth/helpers/login'
require_relative '../auth/pages/forgot_password'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../auth/pages/reset_password'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'
require_relative '../root/pages/right_nav'
require_relative '../settings/pages/user_settings' 

describe '[Auth - Reset Password]', :app_client, :auth do
  include Login
  include MailtrapHelper

  let(:base_page) { BasePage.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:forgot_password) { ForgotPassword.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:reset_password) { ResetPassword.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:user_settings) { UserSettings.new(@driver) }

  context('[as cc user] From login page,') do 
    let(:email) {Login::CC_HARVARD}

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

      expect(login_email.page_displayed?).to be_truthy
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

  context('[as org user] From user settings page,') do 
    before { 
      log_in_as(Login::RESET_PW_USER)
      user_menu.go_to_user_settings
      expect(user_settings.page_displayed?).to be_truthy
    } 

    it 'cannot reset password to an unsecure password', :uuqa_803 do 
      user_settings.change_password(Login::UNSECURE_PASSWORD) 
      notification_text = notifications.error_text
      expect(notification_text).to include(Notifications::UNSECURE_PASSWORD) 
    end

    it 'can reset password to a secure password', :uuqa_247, :only do 
      new_pw = Faker::Internet.password(min_length: 8)
      user_settings.change_password(new_pw)
      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::USER_UPDATED)

      base_page.wait_for_notification_to_disappear

      user_menu.log_out 

      # try logging in w old pw
      log_in_as(Login::RESET_PW_USER)
      expect(login_password.invalid_alert_displayed?).to be_truthy

      # log in w new password 
      log_in_as(Login::RESET_PW_USER, new_pw) 
      expect(home_page.page_displayed?).to be_truthy
      
      #set pw back to original
      user_menu.go_to_user_settings
      user_settings.change_password(Login::DEFAULT_PASSWORD)
      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::USER_UPDATED)
    end
  end
end
