require_relative '../auth/helpers/login'
require_relative '../root/pages/banner'
require_relative '../root/pages/left_nav'
require_relative '../root/pages/notifications'
require_relative './pages/network_browse_drawer'
require_relative './pages/network_browse_map'

describe '[Network - Browse Map - Browse Drawer]', :network, :app_client do
  include Login

  let(:banner) { Banner.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:network_browse_drawer) { NetworkBrowseDrawer.new(@driver) }
  let(:network_browse_map) { NetworkBrowseMap.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as cc user]') do
    before do
      log_in_as(Login::CC_HARVARD)
      left_nav.go_to_my_network
      expect(network_browse_map.page_displayed?).to be_truthy
      expect(network_browse_map.provider_card_first_displayed?).to be_truthy
    end

    it 'shares provider details via email', :uuqa_652 do
      # UU3-49164 workaround for banner blocking drawer elements
      banner.dismiss_alert_if_displayed
      network_browse_map.click_first_provider_detail
      expect(network_browse_drawer.drawer_displayed?).to be_truthy

      network_browse_drawer.click_share_button
      expect(network_browse_drawer.share_form_displayed?).to be_truthy

      address = Faker::Internet.email.to_s
      network_browse_drawer.share_provider_details_via_email(address)

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::MESSAGE_SENT_SUCESS)

      network_browse_drawer.close_drawer
      expect(network_browse_drawer.drawer_not_displayed?).to be_truthy
    end
  end
end
