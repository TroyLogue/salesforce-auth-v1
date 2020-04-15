require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/forgot_password'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page'

describe '[Auth - Reset Password]', :app_client, :auth do
  include Login

  let(:base_page) { BasePage.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:forgot_password) {ForgotPassword.new(@driver) }
  let(:login_email) {LoginEmail.new(@driver) }
  let(:login_password) {LoginPassword.new(@driver) }

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
    end

    it 'cancels password reset', :uuqa_12 do 
      forgot_password.cancel_password_reset

      expect(login_email.page_displayed?).to be_truthy
    end
  end
end
