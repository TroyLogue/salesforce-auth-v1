# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page'
require_relative './pages/new_referral'
require_relative './pages/referral_assessment'
require_relative '../network/pages/provider_drawer'
require_relative '../cases/pages/case_detail_page'
require_relative '../cases/pages/cases_table'

describe '[Referrals Out of Network]', :ehr, :ehr_referrals do
  include LoginEhr

  let(:case_detail) { CaseDetailPage.new(@driver) }
  let(:cases_table) { CasesTable.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:new_referral) { NewReferral.new(@driver) }
  let(:provider_drawer) { ProviderDrawer.new(@driver) }
  let(:referral_assessment) { ReferralAssessment.new(@driver) }

  context('[default view] from Create Referral button') do
    before do
      @service_type = "Disability Benefits"

      log_in_default_as(LoginEhr::CC_HARVARD)
      expect(homepage.default_view_displayed?).to be_truthy

      homepage.go_to_create_referral
      expect(new_referral.page_displayed?).to be_truthy
    end

    it 'can create an OON referral using provider add/remove button', :uuqa_397 do
      description = Faker::Lorem.sentence(word_count: 5)

      primary_worker = new_referral.create_oon_referral_from_table(
        service_type: @service_type,
        description: description
      )
      referral_assessment.create_referral if referral_assessment.page_displayed?

      # after sending referral, verify redirect to home page
      expect(homepage.default_view_displayed?).to be_truthy

      cases_table.click_first_case
      expect(case_detail.page_displayed?).to be_truthy
      expect(case_detail.description_text).to include(description)
      expect(case_detail.case_info_primary_worker).to include(primary_worker)
    end
  end
end
