# frozen_string_literal: true

require_relative '../root/pages/home_page'
require_relative '../root/pages/dashboard_nav'
require_relative '../clients/pages/clients_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../facesheet/pages/facesheet_overview_page'
require_relative '../facesheet/pages/facesheet_forms_page'
require_relative './pages/new_screening_page'

describe '[Screenings - Refuse PRAPARE Screening]', :screenings, :app_client do
  let(:home_page) { HomePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:clients_page) { ClientsPage.new(@driver) }
  let(:facesheet_overview) { FacesheetOverview.new(@driver) }
  let(:facesheet_forms) { FacesheetForms.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:new_screening_page) { NewScreeningPage.new(@driver) }

  context('[As a user with screening role]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_WITH_SCREENING_ROLE)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      left_nav.go_to_clients
      clients_page.go_to_facesheet_random_authorized_client
      expect(facesheet_overview.page_displayed?).to be_truthy
      expect(facesheet_header.page_displayed?).to be_truthy
      facesheet_header.go_to_forms
    end

    it "'No need for resources' warning is displayed in the PRAPARE screening form when client refuses to continue",
       :uuqa_1755 do
      facesheet_forms.create_new_screening
      new_screening_page.refuse_prapare_screening
      expect(new_screening_page.prapare_no_resources_needed_message_displayed?).to be true
    end
  end
end
