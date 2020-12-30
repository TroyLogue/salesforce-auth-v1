# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page'
require_relative './pages/new_referral'
require_relative './pages/referral_assessment'
require_relative '../network/pages/provider_drawer'

describe '[Referrals]', :ehr, :ehr_referrals do
  include LoginEhr

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:new_referral) { NewReferral.new(@driver) }
  let(:provider_drawer) { ProviderDrawer.new(@driver) }
  let(:referral_assessment) { ReferralAssessment.new(@driver) }

  context('[default view]') do
    before do
      @service_type = "Disability Benefits"

      log_in_default_as(LoginEhr::CC_HARVARD)
      expect(homepage.default_view_displayed?).to be_truthy

      homepage.go_to_create_referral
      expect(new_referral.page_displayed?).to be_truthy
    end

    it 'can create a referral using provider add/remove buttons', :uuqa_1614 do
      # select two random providers from table and enable auto-recall option
      description = Faker::Lorem.sentence(word_count: 5)

      new_referral.select_service_type_by_text(@service_type)
      2.times do
        new_referral.add_random_provider_from_table
      end
      new_referral.select_auto_recall
      new_referral.enter_description(description)
      new_referral.submit

      referral_assessment.create_referral if referral_assessment.page_displayed?

      # after sending referral, verify redirect to home page
      expect(homepage.default_view_displayed?).to be_truthy
    end

    it 'can create a referral using provider drawer', :uuqa_1615 do
      description = Faker::Lorem.sentence(word_count: 5)

      new_referral.select_service_type_by_text(@service_type)
      new_referral.open_random_provider_drawer
      expect(provider_drawer.referral_page_displayed?).to be_truthy
      provider_drawer.add_provider
      provider_drawer.close_drawer

      new_referral.enter_description(description)
      new_referral.submit

      referral_assessment.create_referral if referral_assessment.page_displayed?

      # after sending referral, verify redirect to home page
      expect(homepage.default_view_displayed?).to be_truthy
    end
  end
end
