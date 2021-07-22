# frozen_string_literal: true

require_relative '../root/pages/banner'
require_relative '../root/pages/home_page'
require_relative '../root/pages/left_nav'
require_relative '../root/pages/notifications'
require_relative './pages/network_browse_drawer'
require_relative './pages/network_organizations'
require_relative './pages/network_navigation'

describe '[Network - Organizations - Browse Drawer]', :network, :app_client do
  let(:banner) { Banner.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:network_browse_drawer) { NetworkBrowseDrawer.new(@driver) }
  let(:network_navigation) { NetworkNavigation.new(@driver) }
  let(:network_organizations) { NetworkOrganizations.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as a Network Directory User]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_01_USER)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      left_nav.go_to_my_network
      network_navigation.go_to_org_tab
      expect(network_organizations.page_displayed?).to be_truthy
    end

    it 'shares provider details via text from the organizations tab', :uuqa_1785 do
      # UU3-49164 workaround for banner blocking drawer elements
      banner.dismiss_alert_if_displayed
      network_organizations.click_first_provider_row
      expect(network_browse_drawer.drawer_displayed?).to be_truthy

      network_browse_drawer.click_share_button
      expect(network_browse_drawer.share_form_displayed?).to be_truthy

      phone = NetworkBrowseDrawer::VALID_PHONE_NUMBER
      network_browse_drawer.share_provider_details_via_phone(phone)

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::MESSAGE_SENT_SUCCESS)

      network_browse_drawer.close_drawer
      expect(network_browse_drawer.drawer_not_displayed?).to be_truthy
    end
  end
end
