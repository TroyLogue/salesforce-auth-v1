# frozen_string_literal: true

require_relative '../root/pages/notifications'
require_relative './pages/account_info_page'

describe '[User Settings - Update Personal Info]', :user_settings, :app_client do
  let(:notifications) { Notifications.new(@driver) }
  let(:user_settings_account_info_page) { UserSettings::AccountInfoPage.new(@driver) }

  context('[As a user]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::SETTINGS_USER)
      user_settings_account_info_page.authenticate_and_navigate_to(token: @auth_token,
                                                                   path: UserSettings::AccountInfoPage::PATH)
    end

    it 'updates my work title', :uuqa_1610 do
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
