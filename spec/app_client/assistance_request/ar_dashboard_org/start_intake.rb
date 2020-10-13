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
  let(:ar_page) { AsistanceRequest.new(@driver) }
  let(:intake_page) { Intake.new(@driver) }

  before {
    @ar_id = Setup::Data::submit_assistance_request_to_columbia_org

    log_in_as(Login::ORG_COLUMBIA)
    expect(homepage.page_displayed?).to be_truthy
  }

  it 'start intake from AR', :uuqa_1402 do
    ar_page.go_to_new_ar_with_id(ar_id: @ar_id)
    ar_page.select_start_intake_action
    full_name = intake_page.get_clients_full_name
    ssn_number = Faker::IDNumber.valid
    intake_page.complete_required_information(ssn_number)
    intake_page.save_intake
    ar_page.ar_details_page_displayed?
    expect(ar_page.intake_created_text).to include("Intake created for #{full_name}")
  end

  after {
    Setup::Data::close_columbia_assistance_request(contact_id: @ar_id)
  }
end