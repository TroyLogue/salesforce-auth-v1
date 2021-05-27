# frozen_string_literal: true

require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative './pages/org_settings_programs_page'

describe '[Org Settings - Programs]', :org_settings, :app_client do
  let(:home_page) { HomePage.new(@driver) }
  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:org_settings_program_table) { OrgSettings::ProgramTable.new(@driver) }
  let(:org_settings_program_form) { OrgSettings::ProgramForm.new(@driver) }

  context('[as an org admin]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::SETTINGS_USER)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      org_menu.go_to_programs
      expect(org_settings_program_table.page_displayed?).to be_truthy
    end

    it 'can create a new program', :uuqa_175 do
      org_settings_program_table.go_to_new_program_form
      expect(org_settings_program_form.page_displayed?).to be_truthy
    end

    it 'can edit existing program', :uuqa_175 do
      org_settings_program_table.edit_program(name: 'Referred Out of Network')
      expect(org_settings_program_form.get_program_title).to eql('Edit Referred Out of Network')
      org_settings_program_form.save_changes
      expect(org_settings_program_table.are_changes_saved?).to be_truthy
    end

    it 'warning dialog displays when changing referral status', :uuqa_808 do
      org_settings_program_table.edit_program(name: 'Referred Out of Network')
      expect(org_settings_program_form.get_program_referral_dialog).to eql('This program will now begin receiving new referrals')
      org_settings_program_form.toggle_program_referral
      expect(org_settings_program_form.get_program_referral_dialog).to eql('All current referrals and cases will remain active but there will be no NEW incoming referrals for this program until the status is set back')
    end
  end
end
