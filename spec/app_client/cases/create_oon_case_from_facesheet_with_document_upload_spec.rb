# frozen_string_literal: true

require_relative '../cases/pages/case'
require_relative '../cases/pages/case_review'
require_relative '../cases/pages/create_case'
require_relative '../cases/pages/open_cases_dashboard'
require_relative '../facesheet/pages/facesheet_cases_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../facesheet/pages/facesheet_uploads_page'
require_relative '../root/pages/notifications'

describe '[cases]', :app_client, :cases do
  let(:case_detail_page) { Case.new(@driver) }
  let(:create_case) { CreateCase.new(@driver) }
  let(:facesheet_cases_page) { FacesheetCases.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:facesheet_uploads_page) { FacesheetUploadsPage.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:open_cases_dashboard) { OpenCasesDashboard.new(@driver) }
  let(:case_review) { CaseReview.new(@driver) }

  context('[as cc user]') do
    before do
      @contact = Setup::Data.create_harvard_client_with_consent

      # set up file for upload:
      @file_name = Faker::Alphanumeric.alpha(number: 8) + '.txt'
      @local_file_path = create_consent_file(@file_name)

      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      cases_path = facesheet_header.path(contact_id: @contact.contact_id, tab: 'cases')
      facesheet_header.authenticate_and_navigate_to(token: @auth_token, path: cases_path)
      expect(facesheet_cases_page.page_displayed?).to be_truthy
    end

    it 'creates oon case from facesheet with document upload', :uuqa_1806 do
      facesheet_cases_page.create_new_case
      expect(create_case.page_displayed?).to be_truthy
      expect(create_case.is_oon_program_auto_selected?).to be_truthy

      description = Faker::Lorem.sentence(word_count: 5)
      submitted_case_selections = create_case.create_oon_case_selecting_first_options(
        description: description,
        file_path: @local_file_path
      )

      expect(case_review.page_displayed?).to be_truthy

      case_review_selections = {
        service_type: case_review.service_type,
        org: case_review.referred_to,
        primary_worker: case_review.primary_worker
      }
      expect(case_review_selections).to eq submitted_case_selections
      expect(case_review.notes).to eq description
      expect(case_review.document_uploaded?(file_name: @file_name)).to be_truthy
      case_review.click_submit_button

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::CASE_CREATED)
      expect(open_cases_dashboard.open_cases_table_displayed?).to be_truthy

      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id, tab: 'Cases')
      facesheet_cases_page.click_first_case
      expect(case_detail_page.page_displayed?).to be_truthy
      expect(case_detail_page.document_list).to eq(@file_name)

      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id, tab: 'Uploads')
      expect(facesheet_uploads_page.document_uploaded?(file_name: @file_name)).to be_truthy
    end

    after do
      # delete file locally:
      # doing this before creating the case prevents the case from saving,
      # so doing this cleanup after the test is complete
      delete_consent_file(@file_name)
    end
  end
end
