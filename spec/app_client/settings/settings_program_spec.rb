require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/right_nav'
require_relative './pages/settings_programs_page'

describe '[Settings - Programs]', :settings, :app_client do
  include Login

  let(:login_email) {LoginEmail.new(@driver) }
  let(:login_password) {LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:program_table) { Settings::ProgramTable.new(@driver) }
  let(:program_form) { Settings::ProgramCard.new(@driver) }  
  
  context('[as cc user]') do
    before {
      log_in_as(Login::CC_HARVARD)
      org_menu.go_to_programs
      expect(program_table.page_displayed?).to be_truthy
    }

    it 'can edit existing program', :uuqa_355 do
      program_table.edit_program(name: 'Referred Out of Network')
      expect(program_form.get_program_title).to eql('Edit Referred Out of Network')
    end

  end
end
