require_relative '../auth/helpers/login'
require_relative '../root/pages/left_nav'
require_relative './pages/network_browse_map'

describe '[Network - Browse Map]', :network, :app_client do
  include Login

  let(:left_nav) { LeftNav.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:network_browse_map) { NetworkBrowseMap.new(@driver) }

  context('[as cc user]') do
    before {
      log_in_as(Login::CC_HARVARD)
      left_nav.go_to_my_network
      expect(network_browse_map.page_displayed?).to be_truthy
      expect(network_browse_map.provider_card_first_displayed?).to be_truthy
    }

    it 'filters providers by network scope', :uuqa_292 do
      network_browse_map.click_filter_by_network_scope()
      first_option_text = network_browse_map.text_of_first_network_scope()
      network_browse_map.select_first_network_scope()

      expect(first_option_text).to eq(network_browse_map.selected_option_text)
      expect(network_browse_map.provider_card_oon_not_displayed?).to be_truthy
    end
  end
end
