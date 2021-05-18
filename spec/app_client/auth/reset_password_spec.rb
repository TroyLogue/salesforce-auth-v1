require_relative '../../../lib/mailtrap_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/forgot_password'
require_relative '../auth/pages/reset_password'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'
require_relative '../root/pages/right_nav'

describe '[Auth - Reset Password]', :app_client, :auth, order: :defined do
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

  context('[as app-client user] From login page,') do
    let(:email) { Login::NON_EHR_USER }

    before do
      base_page.get ''
      expect(login_email.page_displayed?).to be_truthy

      login_email.submit(email)
      expect(login_password.page_displayed?).to be_truthy

      login_password.click_forgot_password
      expect(forgot_password.page_displayed?).to be_truthy
      expect(forgot_password.user_email_value).to include(email)
    end

    it 'sends reset password email', :uuqa_11, :uuqa_171 do
      forgot_password.click_to_send_email
      expect(login_password.page_displayed?).to be_truthy
      expect(login_email.password_reset_message_displayed?).to be_truthy

      # verify in mailtrap:
      message = get_first_password_reset_email
      expect(message_sent_to(message)).to include(email)

      # verify that the link from the email leads to reset pw page
      reset_link = get_first_reset_link
      @driver.get(reset_link)
      expect(reset_password.page_displayed?).to be_truthy
    end

    it 'cancels password reset', :uuqa_12 do
      forgot_password.cancel_password_reset

      expect(login_email.page_displayed?).to be_truthy
    end
  end

  context('[as app-client and emr user] From login page,') do
    let(:email) { Login::EHR_USER }

    before do
      base_page.get ''
      expect(login_email.page_displayed?).to be_truthy

      login_email.submit(email)
      expect(login_password.page_displayed?).to be_truthy

      login_password.click_forgot_password
      expect(forgot_password.page_displayed?).to be_truthy
      expect(forgot_password.user_email_value).to include(email)
    end

    it 'sends email notifying user their password can only be reset manually', :uuqa_1921 do
      forgot_password.click_to_send_email
      expect(login_password.page_displayed?).to be_truthy
      expect(login_email.password_reset_message_displayed?).to be_truthy

      # verify in mailtrap:
      message = get_first_reset_password_request_email
      expect(message_sent_to(message)).to include(email)

      # verify that the emr user gets the email notifying they can not reset pw via email and have to contact UU to reset pw
      expect(is_manual_password_reset_email?(message)).to be_truthy
    end
  end
end
