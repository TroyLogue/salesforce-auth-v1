# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../intakes/pages/intake'
require_relative '../root/pages/right_nav'
require_relative '../org_settings/pages/org_settings_user_page'

describe '[Intake]', :app_client, :intake do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:intake_page) { Intake.new(@driver) }
  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:org_settings_user_table) { OrgSettings::UserTable.new(@driver) }
  let(:org_settings_user_form) { OrgSettings::UserCard.new(@driver) }

  context('[as org user]') do
    before do
      # Create Contact
      @contact = Setup::Data.create_yale_client_with_consent

      # Add Intake to Client
      @intake = Setup::Data.create_intake_for_yale(
        contact_id: @contact.contact_id,
        fname: @contact.fname,
        lname: @contact.lname,
        dob: @contact.dob
      )

      log_in_as(Login::ORG_YALE)
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'cannot assign inactive users as care coordinator', :uuqa_1681 do
      org_menu.go_to_users_table
      expect(org_settings_user_table.page_displayed?).to be_truthy

      org_settings_user_table.go_to_first_user
      org_settings_user_form.save_user_status(status: OrgSettings::UserCard::USER_STATUS_INACTIVE_TEXT)
      name = org_settings_user_form.get_name

      intake_page.go_to_edit_intake_for_contact(intake_id: @intake.id, contact_id: @contact.contact_id)
      expect(intake_page.page_displayed?).to be_truthy

      expect(intake_page.care_coordinator_list_not_include(name)).to be_truthy
    end
  end
end
