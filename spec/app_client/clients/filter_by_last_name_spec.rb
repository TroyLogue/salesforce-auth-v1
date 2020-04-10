require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/left_nav'
require_relative './pages/clients_page'

describe '[Dashboard - Client - Filter]', :clients, :app_client do
  include Login

  let(:left_nav) { LeftNav.new(@driver) }
  let(:login_email) {LoginEmail.new(@driver) }
  let(:login_password) {LoginPassword.new(@driver) }
  let(:clients_page) { ClientsPage.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }

  context('[as cc user]') do
    before {
      log_in_as(Login::CC_HARVARD)
      left_nav.go_to_clients
      expect(clients_page.page_displayed?).to be_truthy
    }

    it 'Filters clients by last name' do
      clients_page.click_filter_lastname_letter('L')
      expect(clients_page.get_client_name_list).to all(start_with('L'))
    end
  end

end
