require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative '../clients/pages/search_client_page'
require_relative '../clients/pages/confirm_client_page'
require_relative '../clients/pages/add_client_page'

describe '[Menu - New Client - Search]', :clients, :app_client do
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
    }

    it 'Search for an existing client', :uuqa_1301 do
      # Create Contact
      @contact = Setup::Data.create_columbia_client_with_all_fields(token: base_page.get_uniteus_api_token)

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
        dob: @contact.dob_formatted,
        phone: @contact.formatted_phone,
        addresses: @contact.formatted_address,
        military_affiliation: @contact.military_affiliation_key)).to be_truthy
    end

    it 'Search for a non-existing client', :uuqa_1300 do
      fname = Faker::Name.first_name
      lname = Faker::Name.last_name
      dob = Faker::Time.backward(days: 1000).strftime('%m/%d/%Y')

      create_menu.start_new_client
      expect(search_client_page.page_displayed?).to be_truthy

      # Search newly created client with info from above
      search_client_page.search_client(fname: fname, lname: lname, dob: dob)

      # Fields are pre-filled with latest information
      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(
        fname: fname,
        lname: lname,
        dob: dob)).to be_truthy
    end
  end
end
