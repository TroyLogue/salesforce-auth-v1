require_relative '../auth/helpers/login'
require_relative '../root/pages/left_nav'
require_relative '../root/pages/notifications'
require_relative './pages/network_browse_drawer'
require_relative './pages/network_browse_map'

describe '[Network - Browse Map - Browse Drawer]', :network, :app_client do
  include Login

  let(:left_nav) { LeftNav.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:network_browse_drawer) { NetworkBrowseDrawer.new(@driver) }
  let(:network_browse_map) { NetworkBrowseMap.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as cc user]') do
    before {
      log_in_as(Login::CC_HARVARD)
      left_nav.go_to_my_network
      expect(network_browse_map.page_displayed?).to be_truthy
    }

    it 'shares provider details via email', :uuqa_652 do
      network_browse_map.click_first_provider_detail()
      expect(network_browse_drawer.drawer_displayed?).to be_truthy

      network_browse_drawer.click_share_button()
      expect(network_browse_drawer.share_form_displayed?).to be_truthy

      address = "#{Faker::Internet.email}"
      network_browse_drawer.share_provider_details_via_email(address)

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::MESSAGE_SENT)

      network_browse_drawer.close_drawer()
      expect(network_browse_drawer.drawer_not_displayed?).to be_truthy
    end
  end
end
