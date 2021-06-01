# frozen_string_literal: true

require_relative '../cases/pages/case'
require_relative '../cases/pages/case_review'
require_relative '../cases/pages/create_case'
require_relative '../cases/pages/open_cases_dashboard'
require_relative '../clients/pages/clients_page'
require_relative '../facesheet/pages/facesheet_cases_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../referrals/pages/referral'
require_relative '../root/pages/home_page'
require_relative '../root/pages/notifications'

describe '[cases]', :app_client, :cases do
  let(:case_detail_page) { Case.new(@driver) }
  let(:create_case) { CreateCase.new(@driver) }
  let(:facesheet_cases_page) { FacesheetCases.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }
  let(:open_cases_dashboard) { OpenCasesDashboard.new(@driver) }
  let(:review_case) { CaseReview.new(@driver) }

  context('[as cc user]') do
    before do
      @contact = Setup::Data.create_harvard_client_with_consent

      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
    end

    it 'uploads a document while creating a case', :uuqa_1806 do
      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id, tab: 'cases')
      expect(facesheet_cases_page.page_displayed?).to be_truthy

      facesheet_cases_page.create_new_case
      expect(create_case.page_displayed?).to be_truthy
      expect(create_case.is_oon_program_auto_selected?).to be_truthy

      description = Faker::Lorem.sentence(word_count: 5)
      @file = Faker::Alphanumeric.alpha(number: 8) + '.txt'
      submitted_case_selections = create_case.create_oon_case_selecting_first_options(description: description,
                                                                                      file_name: @file)
#      create_case.enter_description(description)

      # add document
#      @file = Faker::Alphanumeric.alpha(number: 8) + '.txt'
#      create_case.upload_document(file_name: @file)

#      create_case.advance_to_review_step
      expect(review_case.page_displayed?).to be_truthy

      review_case_selections = {
        service_type: review_case.service_type,
        org: review_case.referred_to,
        primary_worker: review_case.primary_worker
      }
      expect(review_case_selections).to eq submitted_case_selections
      expect(review_case.notes).to eq description
      expect(review_case.document_uploaded?(file_name: @file)).to be_truthy
      byebug
      review_case.click_submit_button

      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::CASE_CREATED)
      expect(open_cases_dashboard.open_cases_table_displayed?).to be_truthy

      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id, tab: 'cases')
      facesheet_cases_page.click_first_case
      expect(case_detail_page.page_displayed?).to be_truthy
      expect(case_detail_page.document_list).to eq(@file)

      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id, tab: 'Uploads')
      expect(facesheet_uploads_page.document_uploaded?(file_name: @file)).to be_truthy
    end
  end
end
