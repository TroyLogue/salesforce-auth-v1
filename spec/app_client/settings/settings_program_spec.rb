require_relative '../auth/helpers/login'
require_relative '../root/pages/right_nav'
require_relative './pages/settings_programs_page'

describe '[Settings - Programs]', :settings, :app_client do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:program_table) { Settings::ProgramTable.new(@driver) }
  let(:program_form) { Settings::ProgramForm.new(@driver) }

  context('[as cc user]') do
    before {
      log_in_as(Login::SETTINGS_USER)
      org_menu.go_to_programs
      expect(program_table.page_displayed?).to be_truthy
    }

    it 'can create a new program', :uuqa_175 do
      program_table.go_to_new_program_form
      expect(program_form.page_displayed?).to be_truthy
    end

    it 'can edit existing program', :uuqa_175 do
      program_table.edit_program(name: 'Referred Out of Network')
      expect(program_form.get_program_title).to eql('Edit Referred Out of Network')
      program_form.save_changes
      expect(program_table.are_changes_saved?).to be_truthy
    end

    it 'warning dialog displays when changing referral status', :uuqa_808 do
      program_table.edit_program(name: 'Referred Out of Network')
      expect(program_form.get_program_referral_dialog).to eql('This program will now begin receiving new referrals')
      program_form.toggle_program_referral
      expect(program_form.get_program_referral_dialog).to eql('All current referrals and cases will remain active but there will be no NEW incoming referrals for this program until the status is set back')
    end
  end
end
