require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/notifications'
require_relative '../clients/pages/search_client_page'
require_relative '../clients/pages/confirm_client_page'
require_relative '../clients/pages/add_client_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../consent/pages/consent_modal'

describe '[Dashboard - Client - Search]', :clients, :app_client do
  let(:homepage) { HomePage.new(@driver) }
  let(:create_menu) { RightNav::CreateMenu.new(@driver) }
  let(:search_bar) { RightNav::SearchBar.new(@driver) }
  let(:search_client_page) { SearchClient.new(@driver) }
  let(:confirm_client_page) { ConfirmClient.new(@driver) }
  let(:add_client_page) { AddClient.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:consent_modal) { ConsentModal.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as a user in an NextGate org]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::NEXTGATE_USER)
      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
      @fname = Faker::Name.first_name
      @lname = Faker::Name.last_name
      @dob = Faker::Time.backward(days: 1000).strftime('%m/%d/%Y')
    end

    # Changes from ES-60 cause delays in user indexing when using Search And Match
    # This test case can be re-evaluated once ES-110 has be investigated
    # The workaround is to search our newly created client in the search bar

    it 'Create a consented NextGate client', :uuqa_901, :uuqa_903, :es_110 do
      # Start creation process by searching for non-existant client
      create_menu.start_new_client
      expect(search_client_page.page_displayed?).to be_truthy
      search_client_page.search_client(fname: @fname, lname: @lname, dob: @dob)

      # No clients should display they should be send directly to pre-filled form
      confirm_client_page.click_create_new_client if confirm_client_page.page_displayed?
      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(
               fname: @fname,
               lname: @lname,
               dob: @dob
             )).to be_truthy

      # Save client, user should land on facesheet of newly created client and now search for client
      add_client_page.save_client
      consent_modal.add_consent_by_document_upload
      expect(facesheet_header.facesheet_name).to eql("#{@fname} #{@lname}")
      notifications.close_banner

      search_bar.go_to_search_results_page("#{@fname} #{@lname}")
      expect(search_bar.are_results_not_displayed?).to be_truthy
      search_bar.go_to_facesheet_of("#{@fname} #{@lname}")

      expect(facesheet_header.facesheet_name).to eql("#{@fname} #{@lname}")
    end
  end

  context('[as cc user]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_02_USER)
      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
      @fname = Faker::Name.first_name
      @lname = Faker::Name.last_name
      @dob = Faker::Time.backward(days: 1000).strftime('%m/%d/%Y')
    end

    # Changes from ES-60 cause delays in user indexing when using Search And Match
    # This test case can be re-evaluated once ES-110 has be investigated
    # The workaround is to search our newly created client in the search bar

    it 'Create a consented client', :uuqa_1300, :es_110 do
      # Start creation process by searching for non-existant client
      create_menu.start_new_client
      expect(search_client_page.page_displayed?).to be_truthy
      search_client_page.search_client(fname: @fname, lname: @lname, dob: @dob)

      # If no clients are matched the user should be send directly to pre-filled form
      confirm_client_page.click_create_new_client if confirm_client_page.page_displayed?
      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(
               fname: @fname,
               lname: @lname,
               dob: @dob
             )).to be_truthy

      # Save client, user should land on facesheet of newly created client and now search for client
      add_client_page.save_client
      consent_modal.add_consent_by_document_upload
      expect(facesheet_header.facesheet_name).to eql("#{@fname} #{@lname}")
      notifications.close_banner

      search_bar.go_to_search_results_page("#{@fname} #{@lname}")
      expect(search_bar.are_results_not_displayed?).to be_truthy
      search_bar.go_to_facesheet_of("#{@fname} #{@lname}")

      expect(facesheet_header.facesheet_name).to eql("#{@fname} #{@lname}")
    end
  end
end
