require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page'
require_relative '../root/pages/navbar'
require_relative './pages/network'

describe '[Network Filter Panel –– ]', :ehr, :network do
  include LoginEhr

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:navbar) { Navbar.new(@driver) }
  let(:network) { Network.new(@driver) }

  context('[as a cc user] In the Dashboard view') do
    before {
      log_in_dashboard_as(LoginEhr::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
      homepage.go_to_my_network
      expect(network.page_displayed?).to be_truthy
    }

    it 'can filter by text', :uuqa_ do

    end

    it 'can filter by service type, distance, and address type' do
    end
  end
end
