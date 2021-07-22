# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative './pages/security_settings_page'
require_relative './pages/two_factor_auth_edit_page'
require_relative './pages/two_factor_auth_new_page'

describe '[User Settings - 2FA]', :app_client, :user_settings do
  include Login

  let(:home_page) { HomePage.new(@driver) }
  let(:security_settings_page) { UserSettings::SecuritySettingsPage.new(@driver) }
  let(:two_factor_auth_edit_page) { UserSettings::TwoFactorAuthEditPage.new(@driver) }
  let(:two_factor_auth_new_page) { UserSettings::TwoFactorAuthNewPage.new(@driver) }

  context('as licensed user') do
    before do
      log_in_as(email_address: Users::CC_01_USER)
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'submits a phone number and invalid code', :uuqa_1628 do
      security_settings_page.load_page
      expect(security_settings_page.page_displayed?).to be_truthy

      security_settings_page.click_two_factor_auth
      expect(two_factor_auth_new_page.page_displayed?).to be_truthy

      two_factor_auth_new_page.submit_phone_number(number: UserSettings::TwoFactorAuthNewPage::VALID_TEST_PHONE_NUMBER)
      expect(two_factor_auth_edit_page.page_displayed?).to be_truthy

      two_factor_auth_edit_page.submit_one_time_password(code: UserSettings::TwoFactorAuthEditPage::INVALID_OTP)
      expect(two_factor_auth_edit_page.resend_code_link_displayed?).to be_truthy
      expect(two_factor_auth_edit_page.flash_alert_text).to include(UserSettings::TwoFactorAuthEditPage::MESSAGE_OTP_INCORRECT)

      two_factor_auth_edit_page.click_cancel
      expect(security_settings_page.page_displayed?).to be_truthy
      expect(security_settings_page.turn_on_two_factor_auth_link_displayed?).to be_truthy
    end
  end
end
