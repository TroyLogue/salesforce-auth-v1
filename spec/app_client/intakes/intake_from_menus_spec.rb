# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative '../intakes/pages/intakes_search'
require_relative '../intakes/pages/intake'

describe '[Intake]', :app_client, :intake do
  include Login

    let(:login_email) { LoginEmail.new(@driver) }
    let(:login_password) { LoginPassword.new(@driver) }
    let(:create_menu) { RightNav::CreateMenu.new(@driver) }
    let(:home_page) {HomePage.new(@driver)}
    let(:intake_page) {Intake.new(@driver)}
    let(:intakes_search_page) {IntakesSearch.new(@driver)}

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_YALE)
      create_menu.start_new_intake
      expect(intakes_search_page.page_displayed?).to be_truthy
    }

    it 'starts intake from menu', :uuqa_82 do
      # fill out required fields
      fname_input = Faker::Name.male_first_name
      lname_input = Faker::Name.last_name
      dob_input = Faker::Time.backward(days: 1000).strftime('%m/%d/%Y')
      intakes_search_page.input_fname_lname_dob(fname_input, lname_input, dob_input)

      # verify required fields are not empty
      expect(intakes_search_page.are_fields_empty?).not_to be_empty

      # creates new client record
      intakes_search_page.search_records
      expect(intake_page.page_displayed?).to be_truthy
    end
  end
end
