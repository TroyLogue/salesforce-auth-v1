# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative '../intakes/pages/intakes_search'
require_relative '../intakes/pages/intake'

describe '[Intake]', :app_client, :intake do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
    let(:login_password) { LoginPassword.new(@driver) }
    let(:base_page) { BasePage.new(@driver) }
    let(:create_menu) { RightNav::CreateMenu.new(@driver) }
    let(:home_page) {HomePage.new(@driver)}
    let(:intake_page) {Intake.new(@driver)}
    let(:intakes_search_page) {IntakesSearch.new(@driver)}
    let(:clients_page) {ClientsPage.new(@driver)}

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_YALE)
      create_menu.start_new_intake
      expect(intakes_search_page.page_displayed?).to be_truthy
    }

    it 'starts intake from menu', :uuqa_82 do
      # fill out required fields
      first_name_input = Faker::Name.male_first_name
      last_name_input = Faker::Name.last_name
      dob_input = Faker::Time.backward(days: 1000).strftime('%m/%d/%Y')
      intakes_search_page.input_first_name(first_name_input)
      intakes_search_page.input_last_name(last_name_input)
      intakes_search_page.input_dob(dob_input)

      # verify required fields are not empty
      expect(intakes_search_page.input_present?).to be_truthy

      # creates new client record
      intakes_search_page.search_records
      expect(intake_page.page_displayed?).to be_truthy
    end
  end
end
