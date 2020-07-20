require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative '../clients/pages/search_client_page'
require_relative '../clients/pages/confirm_client_page'
require_relative '../clients/pages/add_client_page'

describe '[Dashboard - Client - Search]', :clients, :app_client do
  include Login

  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:create_menu) { RightNav::CreateMenu.new(@driver) }
  let(:search_client_page) { SearchClient.new(@driver) }
  let(:confirm_client_page) { ConfirmClient.new(@driver) }
  let(:add_client_page) { AddClient.new(@driver) }

  context('[as cc user]') do
    before {
      log_in_as(Login::NEXTGATE_USER)
      expect(homepage.page_displayed?).to be_truthy

      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent(token: base_page.get_uniteus_api_token)
      puts @contact.contact_id
    }

    it 'Search Existing Client' do
      create_menu.start_new_client
      expect(search_client_page.page_displayed?).to be_truthy

      # Search newly created client with info from above
      search_client_page.search_client(fname: @contact.fname, lname: @contact.lname, dob: @contact.dob_formatted)

      # One result should be returned
      expect(confirm_client_page.page_displayed?).to be_truthy
      expect(confirm_client_page.clients_returned).to be(1)
      confirm_client_page.select_nth_client(index: 0)

      # Fields are pre-filled with latest information
      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(
        fname: @contact.fname,
        lname: @contact.lname,
        dob: @contact.dob_formatted)).to be_truthy

      # Updating fields works

    end
  end
end
