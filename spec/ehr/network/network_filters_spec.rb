require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page'
require_relative '../root/pages/navbar'
require_relative './pages/network'
require_relative './pages/network_filter_drawer'

describe '[Network]', :ehr, :network do
  include LoginEhr

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:navbar) { Navbar.new(@driver) }
  let(:network) { Network.new(@driver) }
  let(:network_filter_drawer) { NetworkFilterDrawer.new(@driver) }

  context('[as a cc user] in the Dashboard view') do
    before {
      log_in_dashboard_as(LoginEhr::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
      navbar.go_to_my_network
      expect(network.page_displayed?).to be_truthy
    }

    it 'can filter by text', :uuqa_1548 do
      @provider_search_text = "Princeton"
      # TODO: https://uniteus.atlassian.net/browse/UU3-48920
      # replace hardcoded search term with provider name from API
      network.search_by_text(text: @provider_search_text)
      # verify at least one result:
      expect(network.search_result_text).to include("result")
      expect(network.first_provider_name).to include(@provider_search_text)
    end

    it 'can filter by service type, distance, and address', :uuqa_1558 do
      # filter by service type
      @service_type = "Disability Benefits"
      network.select_service_type(@service_type)
      # not sure if this line is needed?
#      @service_type_name = @service_type.name.capitalize
      expect(network.search_result_text).to include(@service_type)

      # open filter drawer
      network.open_filter_drawer
      expect(network_filter_drawer.page_displayed?).to be_truthy

      # filter by distance
      @distance = "25 Miles"
      network_filter_drawer.filter_distance_by_miles(@distance)
      expect(network.search_result_text).to include(@distance.downcase);

      # filter by address
      # UU3-27063 uncomment when fixed
#      network_filter_drawer.submit_other_address(nycFiDiOfficeAddress)
#      expect(network.search_result_text).to include(nycFiDiOfficeAddress)

      # close filter drawer
      network_filter_drawer.close_drawer
#      expect(network_filter_drawer.page_displayed?).to be_falsy
    end
  end
end
