# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page_ehr'
require_relative './pages/new_referral'
require_relative './pages/referral_assessment'
require_relative '../root/pages/notifications_ehr'

describe '[Referrals]', :ehr, :ehr_referrals do
  include LoginEhr

  let(:homepage) { HomePageEhr.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:new_referral) { NewReferral.new(@driver) }
  let(:referral_assessment) { ReferralAssessment.new(@driver) }
  let(:notifications) { NotificationsEhr.new(@driver) }

  context('[default view]') do
    before do
      log_in_default_as(LoginEhr::CC_HARVARD)
      expect(homepage.default_view_displayed?).to be_truthy

      homepage.go_to_create_referral
      expect(new_referral.page_displayed?).to be_truthy
    end

    it 'Create a multi-referral', :uuqa_1670 do
      # select two random providers from table and enable auto-recall option
      description_1 = Faker::Lorem.sentence(word_count: 5)
      description_2 = Faker::Lorem.sentence(word_count: 5)

      new_referral.fill_out_referral(description: description_1)
      new_referral.add_another_referral
      new_referral.fill_out_referral(description: description_2)

      new_referral.submit

      referral_assessment.create_referral if referral_assessment.page_displayed?

      # after sending referral, verify redirect to home page
      expect(homepage.default_view_displayed?).to be_truthy
      # multiple success banners are displayed - cannot check them reliably
      expect(notifications.error_notification_not_displayed?).to be_truthy
    end

    it 'Create a multi-referral with in- and oon providers', :uuqa_1771 do
      description_1 = Faker::Lorem.sentence(word_count: 5)
      description_2 = Faker::Lorem.sentence(word_count: 5)

      new_referral.fill_out_referral(
        description: description_1,
        oon: false
      )
      new_referral.add_another_referral
      new_referral.fill_out_referral(
        description: description_2,
        oon: true
      )

      new_referral.submit

      referral_assessment.create_referral if referral_assessment.page_displayed?

      # after sending referral, verify redirect to home page
      expect(homepage.default_view_displayed?).to be_truthy
      # multiple success banners are displayed - cannot check them reliably
      expect(notifications.error_notification_not_displayed?).to be_truthy
    end
  end
end
