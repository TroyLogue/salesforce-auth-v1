# frozen_string_literal: true

require_relative '../root/pages/banner'
require_relative '../root/pages/home_page'
require_relative '../root/pages/left_nav'
require_relative '../root/pages/notifications'
require_relative './pages/network_browse_drawer'
require_relative './pages/network_browse_map'

describe '[Network - Browse Map - Browse Drawer]', :network, :app_client do
  let(:banner) { Banner.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:network_browse_drawer) { NetworkBrowseDrawer.new(@driver) }
  let(:network_browse_map) { NetworkBrowseMap.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as cc user]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      left_nav.go_to_my_network
      expect(network_browse_map.page_displayed?).to be_truthy
      expect(network_browse_map.provider_card_first_displayed?).to be_truthy
    end

    it 'shares provider details via email', :uuqa_652 do
      # UU3-49164 workaround for banner blocking drawer elements
      banner.dismiss_alert_if_displayed
      network_browse_map.click_first_in_network_provider_detail
      expect(network_browse_drawer.drawer_displayed?).to be_truthy

      network_browse_drawer.click_share_button
      expect(network_browse_drawer.share_form_displayed?).to be_truthy

      address = Faker::Internet.email.to_s
      network_browse_drawer.share_provider_details_via_email(address)

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::MESSAGE_SENT_SUCCESS)

      network_browse_drawer.close_drawer
      expect(network_browse_drawer.drawer_not_displayed?).to be_truthy
    end
  end
end
