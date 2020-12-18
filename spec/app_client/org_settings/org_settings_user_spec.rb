# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/notifications'
require_relative '../root/pages/right_nav'
require_relative './pages/org_settings_user_page'

describe '[Org Settings - Users]', :org_settings, :app_client do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:org_settings_user_table) { OrgSettings::UserTable.new(@driver) }
  let(:org_settings_user_form) { OrgSettings::UserCard.new(@driver) }

  context('[as an org admin]') do
    before do
      log_in_as(Login::SETTINGS_USER)
      org_menu.go_to_users_table
      expect(org_settings_user_table.page_displayed?).to be_truthy
    end

    it 'displays users in alphabetical order', :uuqa_809 do
      expect(org_settings_user_table.get_list_of_user_names.each_cons(2).all? { |a, b| a.downcase <= b.downcase }).to be_truthy
    end

    it 'can view new user form', :uuqa_354 do
      org_settings_user_table.go_to_new_user_form
      expect(org_settings_user_form.get_user_title).to eql('New User')
      expect(org_settings_user_form.new_user_fields_display?).to be_truthy
    end

    it 'can view and edit existing user form', :uuqa_355 do
      org_settings_user_table.go_to_first_user
      expect(org_settings_user_form.existing_user_fields_editable?).to be_truthy
      org_settings_user_form.save_email_field

      notification_text = notifications.success_text
      expect(notification_text).to eql Notifications::USER_UPDATED
    end
  end
end
