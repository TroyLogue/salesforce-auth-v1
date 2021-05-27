# frozen_string_literal: true

require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative '../clients/pages/add_client_page'
require_relative '../clients/pages/confirm_client_page'
require_relative '../clients/pages/search_client_page'
require_relative '../intakes/pages/intake'

describe '[Intake]', :app_client, :intake do
  let(:create_menu) { RightNav::CreateMenu.new(@driver) }
  let(:home_page) {HomePage.new(@driver)}
  let(:intake_page) {Intake.new(@driver)}
  let(:add_client_page) { AddClient.new(@driver) }
  let(:confirm_client_page) { ConfirmClient.new(@driver) }
  let(:search_client_page) { SearchClient.new(@driver) }

  context('[as a user with Intakes User role]') do
    before {
      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_YALE)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      create_menu.start_new_intake
      expect(search_client_page.page_displayed?).to be_truthy
    }

    it 'starts intake from menu for new client', :uuqa_82 do
      # fill out required fields
      fname = Faker::Name.first_name
      lname = Faker::Name.last_name
      dob = Faker::Time.backward(days: 1000).strftime('%m/%d/%Y')
      search_client_page.search_client(fname: fname, lname: lname, dob: dob)

      # No clients should display they should be send directly to pre-filled form
      # But in the event of Faker returning the same data twice, we can create a new client
      confirm_client_page.click_create_new_client if confirm_client_page.check_page_displayed?

      expect(intake_page.page_displayed?).to be_truthy
    end
  end
end
