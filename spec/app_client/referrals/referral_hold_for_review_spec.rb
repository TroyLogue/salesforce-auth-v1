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
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:inreview_referral_dashboard) { ReferralDashboard::InReview.new(@driver) }

  context('[as org user]') do
    before {
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(
        contact_id: @contact.contact_id
      )

      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'user can hold referral for review', :uuqa_909 do
      referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)
      note = Faker::Lorem.sentence(word_count: 5)
      servicetype = 'Disability Benefits'

      # Hold Referral and wait for table to load
      date = referral.hold_for_review_action(note: note)
      expect(inreview_referral_dashboard.page_displayed?).to be_truthy
      expect(inreview_referral_dashboard.org_headers_displayed?).to be_truthy
      expect(inreview_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(servicetype, date)

      # Navigate to In Review Referral and verify status
      referral.go_to_in_review_referral_with_id(referral_id: @referral.referral_id)
      expect(referral.status).to eq(referral.class::IN_REVIEW_STATUS)
    end

    after {
      # Clean up and accepting referral
      @accept_referral = Setup::Data.accept_referral_from_harvard_in_princeton(
        referral_id: @referral.referral_id
      )
    }
  end
end
