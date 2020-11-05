require_relative '../auth/helpers/login_ehr'
require_relative './pages/network'
require_relative './pages/share_drawer'
require_relative '../root/pages/notifications_ehr'

describe '[Network] Share Providers', :ehr, :network do
  include LoginEhr

  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:network) { Network.new(@driver) }
  let(:notifications) { NotificationsEhr.new(@driver) }
  let(:share_drawer) { ShareDrawer.new(@driver) }


  context('[as an EHR Network Directory user] using the Share drawer') do
    before {
      # user only has Network Directory permissions
      # so expect to land on the network page after login
      log_in_default_as(LoginEhr::NETWORK_DIRECTORY_USER)
      expect(network.page_displayed?).to be_truthy
    }

    it 'can share a provider via SMS', :uuqa_400 do
      first_provider_name = network.first_provider_name
      network.add_first_provider
      network.click_share

      expect(share_drawer.page_displayed?).to be_truthy
      expect(share_drawer.provider_list_text).to include(first_provider_name)
      expect(share_drawer.header_text).to eq("Share 1 Organization")

      # share to a valid phone number
      share_drawer.share_by_sms(ShareDrawer::VALID_PHONE_NUMBER)

      # verify "Message sent" notification
      notification_text = notifications.success_text
      expect(notification_text).to include(NotificationsEhr::MESSAGE_SENT)
      expect(network.drawer_closed?).to be_truthy
    end

    it 'can share a provider via email', :uuqa_401 do
    end

    it 'can share a provider via print', :uuqa_402 do
    end
  end
end
