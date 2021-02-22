# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative '../root/pages/dashboard_nav'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../facesheet/pages/facesheet_overview_page'
require_relative '../facesheet/pages/facesheet_forms_page'
require_relative './pages/new_screening_page'

describe '[Screenings - Refuse PRAPARE Screening]', :screenings, :app_client do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:clients_page) { ClientsPage.new(@driver)}
  let(:facesheet_overview_page) { FacesheetOverviewPage.new(@driver) }
  let(:facesheet_forms) { FacesheetForms.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:new_screening_page) { NewScreeningPage.new(@driver) }

  context('[As a user with screening role]') do
    before {
      log_in_as(Login::ORG_NEWYORK)
      expect(homepage.page_displayed?).to be_truthy
      left_nav.go_to_clients
      clients_page.go_to_facesheet_random_authorized_client
      expect(facesheet_overview_page.page_displayed?).to be_truthy
      expect(facesheet_header.page_displayed?).to be_truthy
      facesheet_header.go_to_forms
    }

    it "'No need for resources' warning is displayed in the PRAPARE screening form when client refuses to continue", :uuqa_1755 do
      facesheet_forms.create_new_screening
      new_screening_page.refuse_prapare_screening
      expect(new_screening_page.no_resources_needed_message_displayed?).to be true
    end
  end
end