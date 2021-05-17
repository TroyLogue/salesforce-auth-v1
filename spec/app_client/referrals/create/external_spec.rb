# frozen_string_literal: true

require_relative './../pages/create_referral'
require_relative '../../auth/helpers/login'
require_relative '../../cases/pages/case'
require_relative '../../cases/pages/open_cases_dashboard'
require_relative '../../facesheet/pages/facesheet_cases_page'
require_relative '../../facesheet/pages/facesheet_header'
require_relative '../../root/pages/home_page'

describe '[Referrals - External]', :app_client, :referrals do
  include Login

  let(:add_referral_page) { CreateReferral::AddReferral.new(@driver) }
  let(:additional_info_page) { CreateReferral::AdditionalInfo.new(@driver) }
  let(:case_detail_page) { Case.new(@driver) }
  let(:facesheet_cases_page) { FacesheetCases.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:final_review_page) { CreateReferral::FinalReview.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:open_cases_dashboard) { OpenCasesDashboard.new(@driver) }

  context('[as a Referral User and Out of Network Cases User]') do
    before(:each) do
      @contact = Setup::Data.create_yale_client_with_consent
      log_in_as(Login::ORG_YALE)
      expect(homepage.page_displayed?).to be_truthy
    end

    it 'creates OON referral to external and custom providers using primary worker search', :uuqa_1633, :uuqa_1901 do
      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id)
      expect(facesheet_header.page_displayed?).to be_truthy

      facesheet_header.refer_client
      expect(add_referral_page.page_displayed?).to be_truthy

      oon_case_selections = add_referral_page.add_oon_case_selecting_first_options(description: Faker::Lorem.sentence(word_count: 5))
      primary_worker = add_referral_page.selected_primary_worker
      custom_org_name = Faker::Educator.university
      add_referral_page.add_custom_org(name: custom_org_name)
      add_referral_page.click_next_button

      # Skip assessments if assessments page appears
      additional_info_page.click_next_button if additional_info_page.page_displayed?
      final_review_page.click_submit_button

      expect(open_cases_dashboard.open_cases_table_displayed?).to be_truthy

      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id, tab: 'Cases')
      facesheet_cases_page.click_first_case
      expect(case_detail_page.page_displayed?).to be_truthy

      expect(case_detail_page.referred_to_array).to contain_exactly(oon_case_selections[:recipients], custom_org_name)
      expect(case_detail_page.primary_worker).to eq primary_worker
    end
  end
end
