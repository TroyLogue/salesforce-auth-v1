# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'
require_relative './pages/account_info_page'

describe '[User Settings - Update Personal Info]', :user_settings, :app_client do
  include Login

  let(:home_page) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:user_settings_account_info_page) { UserSettings::AccountInfoPage.new(@driver) }

  context('[As a user]') do
    before do
      log_in_as(Login::SETTINGS_USER)
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'updates my work title', :uuqa_1614 do
      user_settings_account_info_page.load_page
      expect(user_settings_account_info_page.page_displayed?).to be_truthy

      work_title = Faker::Job.title
      user_settings_account_info_page.edit_work_title(work_title)
      expect(user_settings_account_info_page.personal_info_modal_not_displayed?).to be_truthy

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::USER_UPDATED)

      expect(user_settings_account_info_page.name_and_title).to include(work_title)
    end
  end
end
