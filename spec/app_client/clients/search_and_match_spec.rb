require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative '../clients/pages/search_client_page'
require_relative '../clients/pages/confirm_client_page'
require_relative '../clients/pages/add_client_page'

describe '[Dashboard - Client - Search]', :clients, :app_client do
  let(:homepage) { HomePage.new(@driver) }
  let(:create_menu) { RightNav::CreateMenu.new(@driver) }
  let(:search_client_page) { SearchClient.new(@driver) }
  let(:confirm_client_page) { ConfirmClient.new(@driver) }
  let(:add_client_page) { AddClient.new(@driver) }

  context('[as a cc user]') do
    before {
      # Get a random existing contact
      @contact = Setup::Data.random_existing_harvard_client

      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_01_USER)
      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
    }

    # Changes from ES-60 cause delays in user indexing when using Search And Match
    # This test case can be re-evaluated once ES-110 has be investigated
    # The workaround is randomly select an already existing client that has already been indexed
    it 'Existing Client Information is pre-populated', :uuqa_1301, :es_110 do
      create_menu.start_new_client
      expect(search_client_page.page_displayed?).to be_truthy
      search_client_page.search_client(fname: @contact.fname, lname: @contact.lname, dob: @contact.dob_formatted)

      expect(confirm_client_page.page_displayed?).to be_truthy
      confirm_client_page.select_nth_client(index: 0)

      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(
        fname: @contact.fname,
        lname: @contact.lname,
        dob: @contact.dob_formatted
      )).to be_truthy
    end
  end
end
