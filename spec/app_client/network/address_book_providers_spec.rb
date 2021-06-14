# frozen_string_literal: true

require_relative '../root/pages/banner'
require_relative '../root/pages/home_page'
require_relative '../root/pages/left_nav'
require_relative '../root/pages/notifications'
require_relative './pages/network_browse_drawer'
require_relative './pages/network_organizations'
require_relative './pages/network_navigation'

describe '[Network - Organizations]', :network, :app_client do
  let(:banner) { Banner.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:network_browse_drawer) { NetworkBrowseDrawer.new(@driver) }
  let(:network_navigation) { NetworkNavigation.new(@driver) }
  let(:network_organizations) { NetworkOrganizations.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as a Supervisor]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_NEWYORK)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      left_nav.go_to_my_network
      network_navigation.go_to_org_tab
      expect(network_organizations.page_displayed?).to be_truthy
    end

    it 'edit OON address book provider', :uuqa_263 do
      # UU3-49164 workaround for banner blocking drawer elements
      banner.dismiss_alert_if_displayed

      oon_address_book_provider = 'Miami'
      network_organizations.search_for_provider(provider: oon_address_book_provider)
      network_organizations.click_first_provider_row

      expect(network_browse_drawer.drawer_displayed?).to be_truthy
      expect(network_browse_drawer.can_edit_provider?).to be_truthy

      number = Faker::Number.number(digits: 10)
      network_browse_drawer.edit_and_save_provider_phone_number(number: number)

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::ORG_UPDATED)
    end
  end
end
