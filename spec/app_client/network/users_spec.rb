require_relative '../auth/helpers/login'
require_relative '../root/pages/left_nav'
require_relative '../root/pages/notifications'
require_relative './pages/network_browse_drawer'
require_relative './pages/network_navigation'
require_relative './pages/network_users'

describe '[Network - Users]', :network, :app_client do
  include Login

  let(:left_nav) { LeftNav.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:network_browse_drawer) { NetworkBrowseDrawer.new(@driver) }
  let(:network_navigation) { NetworkNavigation.new(@driver) }
  let(:network_users) { NetworkUsers.new(@driver) }

  let(:notifications) { Notifications.new(@driver) }

  context('[as a Network Directory User]') do
    before do
      log_in_as(Login::CC_HARVARD)
      left_nav.go_to_my_network
      network_navigation.go_to_users_tab
      expect(network_users.page_displayed?).to be_truthy
    end

    it 'Search users', :uuqa_168 do
      text = 'e'
      network_users.search_for(text)

      expect(notifications.error_notification_not_displayed?).to be_truthy
      expect(network_users.no_users_displayed? || network_users.matching_users_displayed?(text))
    end
  end
end
