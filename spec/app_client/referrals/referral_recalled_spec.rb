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
  let(:recalled_referral_dashboard) { ReferralDashboard::Recalled.new(@driver) }
  let(:inreview_referral_dashboard) { ReferralDashboard::InReview.new(@driver) }

  context('[as cc user]') do
    before {
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_yale(
        contact_id: @contact.contact_id
      )

      # Recall Referral
      @recalled_referral = Setup::Data.recall_referral_in_harvard(referral_id: @referral.referral_id,
                                                                  note: Faker::Lorem.sentence(word_count: 5))
      @recalled_date = Time.now.strftime('%l:%M %P').strip
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'close a recalled referral', :uuqa_1578 do
      # Recalled referral displays in recalled referrals dasboard table
      recalledfrom = 'Yale'
      servicetype = 'Disability Benefits'

      recalled_referral_dashboard.go_to_recalled_referrals_dashboard
      expect(recalled_referral_dashboard.page_displayed?).to be_truthy
      expect(recalled_referral_dashboard.headers_displayed?).to be_truthy
      expect(recalled_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(recalledfrom, servicetype, @recalled_date)

      # Navigate to recalled referral
      referral.go_to_recalled_referral_with_id(referral_id: @referral.referral_id)

      # Close referral
      @close_note = Faker::Lorem.sentence(word_count: 5)
      referral.close_referral_action(note: @close_note)

      # Navigate to closed referral
      referral.go_to_closed_referral_with_id(referral_id: @referral.referral_id)

      # Referral is correctly updated
      expect(referral.status).to eql(referral.class::CLOSED_STATUS)
      expect(referral.outcome_notes).to eql(@close_note)
      expect(referral.action_btn_text).to eql(referral.class::CLOSED_REFERRAL_ACTION)
    end
  end
end
