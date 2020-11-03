require_relative '../auth/helpers/login_ehr'
require_relative './pages/network'
require_relative './pages/provider_drawer'
require_relative '../root/pages/notifications_ehr'

describe '[Network] Share from Browse Drawer', :ehr, :network do
  include LoginEhr

  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:network) { Network.new(@driver) }
  let(:notifications) { NotificationsEhr.new(@driver) }
  let(:provider_drawer) { ProviderDrawer.new(@driver) }


  context('[as an EHR Network Directory user]') do
    before {
      # user only has Network Directory permissions
      # so expect to land on the network page after login
      log_in_default_as(LoginEhr::NETWORK_DIRECTORY_USER)
      expect(network.page_displayed?).to be_truthy
    }

    it 'can share a provider by email', :uuqa_482 do
      first_provider_name = network.first_provider_name

      network.click_first_provider_card

      expect(network.drawer_open?).to be_truthy
      expect(provider_drawer.page_displayed?).to be_truthy
      expect(provider_drawer.provider_name).to include(first_provider_name)

      # share to email address (valid email)
      provider_drawer.click_share
      expect(provider_drawer.share_section_displayed?).to be_truthy
      email = "UUQA-482@share.test"
      provider_drawer.share_by_email(email)

      notification_text = notifications.success_text
      expect(notification_text).to include(NotificationsEhr::MESSAGE_SENT)
      expect(network.drawer_closed?).to be_truthy
    end
  end
end
