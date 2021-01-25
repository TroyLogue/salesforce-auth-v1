require_relative '../../auth/helpers/login'
require_relative '../../root/pages/right_nav'
require_relative '../../root/pages/home_page'
require_relative '../../referrals/pages/referral'
require_relative '../../referrals/pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:new_referral_dashboard) { ReferralDashboard::New.new(@driver) }

  context('[as org user]') do
    before {
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent

      # Create referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(contact_id: @contact.contact_id)

      # Select client in Princeton
      @contact = Setup::Data.select_client_in_princeton(contact: @contact)
    }

    it 'user can reject a new referral from an existing client', :uuqa_1048 do
      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy

      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      note = Faker::Lorem.sentence(word_count: 5)

      # Options for rejection are available
      expect(referral.reject_referral_options_displayed?).to be_truthy

      # After user rejects referral, user lands on new referrals dashboard view
      referral.reject_referral_action(note: note)
      expect(new_referral_dashboard.page_displayed?).to be_truthy

      # Referrals status is updated after rejecting
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      expect(referral.status).to eq(referral.class::REJECTED_STATUS)
    end

    it 'user can reject a referral in review', :uuqa_1651 do
      # Hold referral for review
      hold_note = Faker::Lorem.sentence(word_count: 5)
      Setup::Data.hold_referral_in_princeton(note: hold_note)

      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy

      referral.go_to_in_review_referral_with_id(referral_id: @referral.id)
      reject_note = Faker::Lorem.sentence(word_count: 5)

      # Options for rejection are available
      expect(referral.reject_referral_options_displayed?).to be_truthy

      # After user rejects referral, user lands on new referrals dashboard view
      referral.reject_referral_action(note: reject_note)
      expect(new_referral_dashboard.page_displayed?).to be_truthy

      # Referrals status is updated after rejecting
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      expect(referral.status).to eq(referral.class::REJECTED_STATUS)
    end
  end
end
