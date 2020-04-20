require_relative '../../spec_helper'
require_relative '../../../lib/mailtrap_helper' 
require_relative '../auth/helpers/login'
require_relative '../auth/pages/forgot_password'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative '../settings/pages/user_settings' 

describe '[Auth - Reset Password]', :app_client, :auth do
  include Login
  include MailtrapHelper

  let(:base_page) { BasePage.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:forgot_password) {ForgotPassword.new(@driver) }
  let(:login_email) {LoginEmail.new(@driver) }
  let(:login_password) {LoginPassword.new(@driver) }
  let(:right_nav) {RightNav.new(@driver) }
  let(:user_settings) {UserSettings.new(@driver) }

  context('[as cc user] From login page') do 
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

    it 'sends reset password email', :uuqa_11 do 
      forgot_password.click_to_send_email

      expect(login_email.page_displayed?).to be_truthy
      expect(login_email.password_reset_message_displayed?).to be_truthy

      # verify in mailtrap: 
      message = get_first_message
      expect(is_password_reset_email?(message)).to be_truthy
      expect(message_sent_to(message)).to include(email)

      reset_link = get_first_reset_link
      @driver.get(reset_link)
    end

    it 'cancels password reset', :uuqa_12 do 
      forgot_password.cancel_password_reset

      expect(login_email.page_displayed?).to be_truthy
    end
  end

  context('[as cc user] From user settings page, ') do 
    before { 
      log_in_as(Login::CC_HARVARD)
      right_nav.go_to_user_settings
      expect(user_settings.page_displayed?).to be_truthy
    } 

    it 'cannot reset password to an unsecure password' do 
       
    end

    it 'can reset password to a secure password' do 
    end
  end
end
