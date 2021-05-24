# frozen_string_literal: true

require_relative '../root/pages/home_page'
require_relative '../root/pages/left_nav'
require_relative './pages/network_browse_map'

describe '[Network - Browse Map]', :network, :app_client do
  let(:home_page) { HomePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:network_browse_map) { NetworkBrowseMap.new(@driver) }

  context('[as a user with no user address or org address]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_NO_ADDRESS)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      left_nav.go_to_my_network
    end

    it 'displays the browse map', :uuqa_837 do
      expect(network_browse_map.page_displayed?).to be_truthy
    end
  end
end
