require_relative '../auth/helpers/login'
require_relative '../root/pages/left_nav'
require_relative './pages/network_browse_map'

describe '[Network - Browse Map]', :network, :app_client do
  include Login

  let(:left_nav) { LeftNav.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:network_browse_map) { NetworkBrowseMap.new(@driver) }

  context('[as a user with no user address or org address]') do
    before {
      log_in_as(Login::ORG_CHICAGO)
      left_nav.go_to_my_network
    }

    it 'displays the browse map', :uuqa_837 do
      expect(network_browse_map.page_displayed?).to be_truthy
    end
  end
end
