# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/collection_filters_drawer'
require_relative '../root/pages/home_page_ehr'
require_relative './pages/case_detail_page'
require_relative './pages/cases_table'

describe '[Cases]', :ehr, :cases do
  include LoginEhr

  let(:base_page) { BasePage.new(@driver) }
  let(:case_detail_page) { CaseDetailPage.new(@driver) }
  let(:cases_table) { CasesTable.new(@driver) }
  let(:home_page) { HomePageEhr.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }

  context('when on detail page') do
    before do
      contact = Setup::Data.create_harvard_client_with_consent
      @case = Setup::Data.create_service_case_for_harvard(contact_id: contact.contact_id)

      log_in_dashboard_as(LoginEhr::CC_HARVARD)
      expect(home_page.page_displayed?).to be_truthy

      # click first case - just until EHR-525 is fixed
      home_page.go_to_cases_tab
      expect(cases_table.page_displayed?).to be_truthy
      cases_table.click_first_case

      # go to detail page of case created above; requires session_support_id to build EHR URL
#      base_page.get("/#{session_support_id}/2/patient/#{@case.contact.id}/cases/#{@case.id}")
    end

    it 'edits primary worker', :uuqa_1621 do
      expect(case_detail_page.page_displayed?).to be_truthy
      expect(case_detail_page.case_info_primary_worker).to eq @case.primary_case_worker.full_name
      expect(case_detail_page.care_team_primary_worker).to include @case.primary_case_worker.full_name

      updated_primary_worker = case_detail_page.update_primary_worker_to_random_option
      expect(case_detail_page.primary_worker_edit_button_displayed?).to be_truthy
      expect(case_detail_page.case_info_primary_worker).to eq updated_primary_worker

      # bug UU3-49227: Care Team is not updated when the primary worker is edited until refreshed
      base_page.refresh
      expect(case_detail_page.care_team_primary_worker).to eq updated_primary_worker
    end
  end
end
