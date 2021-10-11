# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page_ehr'
require_relative './pages/new_referral'
require_relative './pages/referral_assessment'
require_relative '../network/pages/program_drawer'

describe '[Referrals]', :ehr, :ehr_referrals do
  include LoginEhr

  let(:homepage) { HomePageEhr.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:new_referral) { NewReferral.new(@driver) }
  let(:program_drawer) { ProgramDrawer.new(@driver) }
  let(:referral_assessment) { ReferralAssessment.new(@driver) }

  context('[default view] User can create a referral') do
    before do
      @service_type = "Disability Benefits"

      log_in_default_as(LoginEhr::CC_HARVARD)
      expect(homepage.default_view_displayed?).to be_truthy

      homepage.go_to_create_referral
      expect(new_referral.page_displayed?).to be_truthy
    end

    it 'adding two providers via table', :uuqa_1614 do
      # select two random providers from table
      description = Faker::Lorem.sentence(word_count: 5)

      new_referral.create_referral_from_table(
        service_type: @service_type,
        description: description,
        provider_count: 2
      )
      referral_assessment.create_referral if referral_assessment.page_displayed?

      # after sending referral, verify redirect to home page
      expect(homepage.default_view_displayed?).to be_truthy
    end

    it 'adding a provider using provider drawer', :uuqa_1615 do
      description = Faker::Lorem.sentence(word_count: 5)

      new_referral.select_service_type_by_text(@service_type)
      new_referral.open_random_program_drawer
      expect(program_drawer.referral_page_displayed?).to be_truthy
      program_drawer.add_provider
      program_drawer.close_drawer

      new_referral.enter_description(description)
      new_referral.submit

      referral_assessment.create_referral if referral_assessment.page_displayed?

      # after sending referral, verify redirect to home page
      expect(homepage.default_view_displayed?).to be_truthy
    end
  end
end
