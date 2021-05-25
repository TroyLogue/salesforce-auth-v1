require_relative './pages/clients_page'

describe '[Dashboard - Client - Filter]', :clients, :app_client do
  let(:clients_page) { ClientsPage.new(@driver) }

  context('[as cc user]') do
    before {
      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      clients_page.authenticate_and_navigate_to(token: @auth_token, path: ClientsPage::ALL_CLIENTS_PATH)
      expect(clients_page.page_displayed?).to be_truthy
    }

    it 'Filters clients by last name' do
      clients_page.click_filter_lastname_letter('L')
      expect(clients_page.get_client_name_list).to all(start_with('L'))
    end
  end
end
