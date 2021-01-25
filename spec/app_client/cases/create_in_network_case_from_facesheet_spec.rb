# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../cases/pages/case'
require_relative '../cases/pages/case_review'
require_relative '../cases/pages/create_case'
require_relative '../cases/pages/open_cases_dashboard'
require_relative '../facesheet/pages/facesheet_cases_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'

describe '[cases]', :app_client, :cases do
  include Login

  let(:case_detail_page) { Case.new(@driver) }
  let(:case_review) { CaseReview.new(@driver) }
  let(:create_case) { CreateCase.new(@driver) }
  let(:facesheet_cases_page) { FacesheetCases.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:open_cases_dashboard) { OpenCasesDashboard.new(@driver) }

  context('[as org user]') do
    before do
      @contact = Setup::Data.create_yale_client_with_consent

      log_in_as(Login::ORG_YALE)
      expect(homepage.page_displayed?).to be_truthy
    end

    it 'creates case via facesheet to my org', :uuqa_1640 do
      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id, tab: 'Cases')
      expect(facesheet_cases_page.page_displayed?).to be_truthy

      facesheet_cases_page.create_new_case
      expect(create_case.page_displayed?).to be_truthy

      description = Faker::Lorem.sentence(word_count: 5)
      submitted_case_selections = create_case.create_case_selecting_first_options_and_searching_for_primary_worker(
        description: description,
        primary_worker_search_keys: 'e'
      )

      expect(case_review.page_displayed?).to be_truthy

      case_review_selections = {
        service_type: case_review.service_type,
        primary_worker: case_review.primary_worker
      }
      expect(case_review_selections).to eq submitted_case_selections

      expect(case_review.description_in_network).to eq description

      case_review.click_submit_button

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::CASE_CREATED)
      expect(open_cases_dashboard.open_cases_table_displayed?).to be_truthy

      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id, tab: 'Cases')
      facesheet_cases_page.click_first_case
      expect(case_detail_page.page_displayed?).to be_truthy

      case_detail_selections = {
        service_type: case_detail_page.service_type,
        primary_worker: case_detail_page.primary_worker,
      }
      expect(case_detail_selections).to eq submitted_case_selections
      expect(case_detail_page.notes).to eq description
    end
  end
end
