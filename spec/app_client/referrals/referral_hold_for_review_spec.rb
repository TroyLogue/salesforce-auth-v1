require_relative '../auth/helpers/login'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative '../referrals/pages/referral'
require_relative '../referrals/pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:inreview_referral_dashboard) { ReferralDashboard::InReview.new(@driver) }
  let(:rejected_referral_dashboard) { ReferralDashboard::Rejected.new(@driver) }

  before {
    # Create Contact
    @contact = Setup::Data.create_harvard_client_with_consent

    # Create Referral
    @referral = Setup::Data.send_referral_from_harvard_to_princeton(contact_id: @contact.contact_id)
  }

  context('[as a Referral user]') do
    it 'user can hold a new referral for review', :uuqa_909 do
      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy

      referral.go_to_new_referral_with_id(referral_id: @referral.id)

      # Hold Referral and wait for table to load
      in_review_note = Faker::Lorem.sentence(word_count: 5)
      referral.hold_for_review_action(note: in_review_note)

      expect(inreview_referral_dashboard.page_displayed?).to be_truthy
      expect(inreview_referral_dashboard.org_headers_displayed?).to be_truthy
      expect(inreview_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(@referral.service_type)

      # Navigate to In Review Referral and verify status
      referral.go_to_in_review_referral_with_id(referral_id: @referral.id)
      expect(referral.status).to eq(referral.class::IN_REVIEW_STATUS)

      # Clean up and recalling referral
      Setup::Data.recall_referral_in_harvard(note: 'Data cleanup')
      Setup::Data.close_referral_in_harvard(note: 'Data cleanup')
    end

    it 'user can hold a rejected referral for review', :uuqa_1616 do
      # Reject Referral
      reject_note = Faker::Lorem.sentence(word_count: 5)
      Setup::Data.reject_referral_in_princeton(note: reject_note)

      # Log in as user who originally sent referral
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy

      # Newly rejected referral should appear on dashboard
      rejected_referral_dashboard.go_to_rejected_referrals_dashboard

      expect(rejected_referral_dashboard.page_displayed?).to be_truthy
      expect(rejected_referral_dashboard.headers_displayed?).to be_truthy
      expect(rejected_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(@referral.service_type, @referral.reject_reason)

      # Moving referral to in review
      referral.go_to_rejected_referral_with_id(referral_id: @referral.id)
      in_review_note = Faker::Lorem.sentence(word_count: 5)
      referral.hold_for_review_action(note: in_review_note)

      # Navigate to In Review Referral and verify status
      referral.go_to_in_review_referral_with_id(referral_id: @referral.id)
      expect(referral.status).to eq(referral.class::IN_REVIEW_STATUS)

      # Clean up and recalling referral
      Setup::Data.recall_referral_in_harvard(note: 'Data cleanup')
      Setup::Data.close_referral_in_harvard(note: 'Data cleanup')
    end

    it 'user can hold a recalled referral for review', :uuqa_1661 do
      # recalling referral
      recall_note = Faker::Lorem.sentence(word_count: 5)
      Setup::Data.recall_referral_in_harvard(note: recall_note)

      # Log in as user who originally sent referral
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy

      # Moving referral to in review
      referral.go_to_recalled_referral_with_id(referral_id: @referral.id)
      in_review_note = Faker::Lorem.sentence(word_count: 5)
      referral.hold_for_review_action(note: in_review_note)

      # Navigate to In Review Referral and verify status
      referral.go_to_in_review_referral_with_id(referral_id: @referral.id)
      expect(referral.status).to eq(referral.class::IN_REVIEW_STATUS)

      # Clean up and closing referral
      Setup::Data.close_referral_in_harvard(note: 'Data cleanup')
    end
  end
end
