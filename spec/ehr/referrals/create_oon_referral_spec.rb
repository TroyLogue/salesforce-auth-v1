# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page_ehr'
require_relative './pages/referral_assessment'
require_relative './pages/find_programs'
require_relative './pages/select_service_types'
require_relative './pages/add_description'
require_relative './pages/referral_review'
require_relative '../network/pages/program_drawer'
require_relative '../cases/pages/case_detail_page'
require_relative '../cases/pages/cases_table'

describe '[Referrals Out of Network]', :ehr, :ehr_referrals do
  include LoginEhr

  let(:add_description) { AddDescription.new(@driver) }
  let(:case_detail) { CaseDetailPage.new(@driver) }
  let(:cases_table) { CasesTable.new(@driver) }
  let(:find_programs) { FindPrograms.new(@driver) }
  let(:homepage) { HomePageEhr.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:program_drawer) { ProgramDrawer.new(@driver) }
  let(:referral_assessment) { ReferralAssessment.new(@driver) }
  let(:referral_review) { ReferralReview.new(@driver) }
  let(:select_service_types) { SelectServiceTypes.new(@driver) }

  context('[default view] from Create Referral button') do
    before do
      @service_type = "Disability Benefits"

      log_in_default_as(LoginEhr::CC_HARVARD)
      expect(homepage.default_view_displayed?).to be_truthy

      homepage.go_to_create_referral
      expect(find_programs.page_displayed?).to be_truthy
    end

    it 'can create an OON referral, selecting provider from table', :uuqa_397 do
      description = Faker::Lorem.sentence(word_count: 5)
      find_programs.add_oon_program_from_table
      find_programs.click_next
      expect(select_service_types.page_displayed?).to be_truthy
      select_service_types.select_random_service_type_for_each_referral
      select_service_types.click_next
      expect(add_description.page_displayed?).to be_truthy
      add_description.fill_out_description_card_for_each_referral(description: description)
      add_description.click_next
      referral_assessment.click_next if referral_assessment.page_displayed?
      expect(referral_review.page_displayed?).to be_truthy
      referral_review.complete_referral
      expect(homepage.default_view_displayed?).to be_truthy
      expect(homepage.case_created_popup_displayed?).to be_truthy
      homepage.close_case_created_popup
      cases_table.click_first_case
      expect(case_detail.page_displayed?).to be_truthy
      expect(case_detail.description_text).to include(description)
    end
  end
end
