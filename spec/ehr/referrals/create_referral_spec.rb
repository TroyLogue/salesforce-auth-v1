# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page'
require_relative './pages/new_referral'
require_relative './pages/referrals_table'
require_relative './pages/referral_assessment'

describe '[Referrals]', :ehr, :referrals do
  include LoginEhr

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:new_referral) { NewReferral.new(@driver) }
  let(:referral_assessment) { ReferralAssessment.new(@driver) }
  let(:referrals_table) { ReferralsTable.new(@driver) }

  context('[default view]') do
    before do
      # set constants for both tests:
      @assessment = "Ivy League Intake Form"
      @service_type = "Disability Benefits"

      log_in_default_as(LoginEhr::CC_HARVARD)
      expect(homepage.default_view_displayed?).to be_truthy

      homepage.go_to_create_referral
      expect(new_referral.page_displayed?).to be_truthy
    end

    it 'can create a referral using provider add/remove buttons', :uuqa_1614 do
      # select Princeton and Columbia from table and enable auto-recall option
      # avoid sending new referrals to Yale and Harvard from EMR
      # to avoid conflicts with app-client tests
      description = Faker::Lorem.sentence(word_count: 5)
      providers = ["Princeton", "Columbia"]
      assessment_responses = [Faker::Lorem.word, Faker::Lorem.word]

      new_referral.select_service_type_by_text(@service_type)

      # TODO - remove hardcoding!
      new_referral.add_providers_via_table
#      new_referral.select_providers_from_table(providers)

      new_referral.select_auto_recall
      new_referral.enter_description(description)
      new_referral.click_continue
      expect(referral_assessment.page_displayed?(assessment_name: @assessment)).to be_truthy
      referral_assessment.fill_out_and_create_referral(assessment_responses)

      # after sending referral, verify that the referrals table appears
      # verify the referral you just sent in the table?
      expect(homepage.default_view_displayed?).to be_truthy
    end

    it 'can create a referral using provider drawer', :uuqa_1615 do
=begin
      # select Princeton via provider drawer Add Button
      description = Faker::Lorem.sentence(word_count: 5)
      providers = ["Princeton"]
      assessment_first = Faker::Lorem.word
      assessment_second = Faker::Lorem.word
      new_referral.create_referral_using_provider_drawer(
        service_type: service_type,
        providers: providers,
        description: description,
        assessment_first: assessment_first,
        assessment_second: assessment_second
      )

      # verify referrals table
=end
    end
  end
end
