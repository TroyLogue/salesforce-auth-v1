# frozen_string_literal: true

require_relative '../root/pages/home_page'
require_relative '../root/pages/left_nav'
require_relative '../root/pages/notifications'
require_relative './pages/network_navigation'
require_relative './pages/network_users'

describe '[Network - Users]', :network, :app_client do
  let(:home_page) { HomePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:network_navigation) { NetworkNavigation.new(@driver) }
  let(:network_users) { NetworkUsers.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as a Network Directory User]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_01_USER)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      left_nav.go_to_my_network
      network_navigation.go_to_users_tab
      expect(network_users.page_displayed?).to be_truthy
    end

    it 'Search users', :uuqa_168 do
      text = 'e'
      network_users.search_for(text)

      expect(notifications.error_notification_not_displayed?).to be_truthy
      expect(network_users.no_users_displayed? || network_users.matching_users_displayed?(text)).to be_truthy
    end
  end
end
