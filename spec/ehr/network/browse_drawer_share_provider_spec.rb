require_relative '../auth/helpers/login_ehr'
require_relative './pages/network'
require_relative './pages/program_drawer'
require_relative './pages/share_drawer'
require_relative '../root/pages/notifications_ehr'

describe '[Network] Add Program from Browse Drawer', :ehr, :network do
  include LoginEhr

  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:network) { Network.new(@driver) }
  let(:notifications) { NotificationsEhr.new(@driver) }
  let(:program_drawer) { ProgramDrawer.new(@driver) }
  let(:share_drawer) { ShareDrawer.new(@driver) }

  context('[as an EHR Network Directory user]') do
    before {
      # user only has Network Directory permissions
      # so expect to land on the network page after login
      log_in_default_as(LoginEhr::NETWORK_DIRECTORY_USER)
      expect(network.page_displayed?).to be_truthy
    }

    it 'can add a provider to share via the browse drawer', :uuqa_482 do
      first_program_name = network.first_program_name
      network.click_first_program_card

      expect(program_drawer.page_displayed?).to be_truthy
      expect(program_drawer.program_name).to include(first_program_name)
      provider_name = program_drawer.provider_name
      program_drawer.add_program
      program_drawer.close_drawer

      expect(network.selected_programs_count_text).to eq('1 program selected')

      network.click_share
      expect(share_drawer.page_displayed?).to be_truthy
      expect(share_drawer.provider_list_text).to include(provider_name)
    end
  end
end
