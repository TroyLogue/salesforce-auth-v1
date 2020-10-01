require_relative '../../../spec_helper'
require_relative '../../../shared_components/base_page.rb'
require_relative '../../auth/helpers/login'
require_relative '../../auth/pages/login_email'
require_relative '../../auth/pages/login_password'
require_relative '../../root/pages/home_page'
require_relative '../ar_dashboard_org/pages/ar_dashboard_page.rb'
require_relative '../../intakes/pages/intake.rb'

describe '[AR start intake]', :app_client, :assistance_request do
  include Login
  
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:ar_dashboard_page) { DashboardPage.new(@driver) }
  let(:intake_page) { Intake.new(@driver) }

  before {
    @ar_id = Setup::Data::submit_assistance_request_to_columbia_org

    log_in_as(Login::ORG_COLUMBIA)
    expect(homepage.page_displayed?).to be_truthy
  }

  after {
    Setup::Data::close_assistance_request(contact_id: @ar_id)
  }

  it 'start intake from AR', :uuqa_1402 do
    base_page.get("/dashboard/new/assistance-requests/#{@ar_id}")
    ar_dashboard_page.select_start_intake_action
    ssn_number = Faker::IDNumber.valid
    intake_page.complete_required_information(ssn_number)
    intake_note = Faker::Lorem.sentence(word_count: 5)
    intake_page.add_note(intake_note)
    intake_page.check_first_care_coordinator
    intake_page.check_needs_action
    intake_page.save_intake
    expect(ar_dashboard_page.facesheet_link_text).to eq('GO TO FACE SHEET')
  end
end