require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/right_nav'
require_relative './pages/settings_user_page'

describe '[Settings - Users]', :settings, :app_client do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:user_table) { Settings::UserTable.new(@driver) }
  let(:user_form) { Settings::UserCard.new(@driver) }  
  
  context('[as cc user]') do
    before {
      log_in_as(Login::SETTINGS_USER)
      org_menu.go_to_users_table
      expect(user_table.page_displayed?).to be_truthy
    }

    it 'displays users in alphabetical order', :uuqa_809 do
      expect(user_table.get_list_of_user_names.each_cons(2).all? {|a, b| a.downcase <= b.downcase }).to be_truthy
    end

    it 'can view new user form', :uuqa_354 do
      user_table.go_to_new_user_form
      expect(user_form.get_user_title).to eql('New User')
      expect(user_form.new_user_fields_display?).to be_truthy
    end

    it 'can view and edit existing user form', :uuqa_355 do
      user_table.go_to_user(name: 'Permissions, QA')
      expect(user_form.get_user_title).to eql("QA Permissions's Profile")
      expect(user_form.existing_user_fields_editable?).to be_truthy
      expect(user_form.save_email_field?).to be_truthy
    end
      
  end
end
