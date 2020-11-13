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
  let(:sent_pending_consent_referral_dashboard) { ReferralDashboard::Sent::PendingConsent.new(@driver) }
  let(:p2p_referral_dashboard) { ReferralDashboard::ProviderToProvider.new(@driver) }

  context('[a cc user]') do
    it 'close a provider to provider referral', :uuqa_1625 do
      # Create Contact
      @contact = Setup::Data.create_yale_client_with_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_yale_to_princeton(contact_id: @contact.contact_id)

      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy

      # Referral displays in p2p referrals dasboard table
      recipient = 'Princeton'
      sending = 'Yale'
      service_type = 'Disability Benefits'
      status = 'Needs Action'
      closed_by = 'harvard Ivy'

      p2p_referral_dashboard.go_to_p2p_referrals_dashboard
      expect(p2p_referral_dashboard.page_displayed?).to be_truthy
      expect(p2p_referral_dashboard.headers_displayed?).to be_truthy
      expect(p2p_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(recipient, sending, service_type, status)

      # Navigate to p2p referral
      referral.go_to_recalled_referral_with_id(referral_id: @referral.referral_id)

      # Close referral, only option available
      close_note = Faker::Lorem.sentence(word_count: 5)
      referral.close_referral_through_btn(note: close_note)

      # Navigate to closed referral
      referral.go_to_closed_referral_with_id(referral_id: @referral.referral_id)

      # Referral is correctly updated
      expect(referral.status).to eql(referral.class::CLOSED_STATUS)
      expect(referral.outcome_notes).to eql(close_note)
      expect(referral.action_btn_text).to eql(referral.class::CLOSED_REFERRAL_ACTION)
      expect(referral.closed_by).to eql(closed_by)
    end
  end

  context('[as a Referral user]') do
    it 'close a recalled referral', :uuqa_1578 do
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_yale(contact_id: @contact.contact_id)

      # Recall Referral
      Setup::Data.recall_referral_in_harvard(referral_id: @referral.referral_id, note: 'Recalling Referral')
      recalled_date = Time.now.strftime('%l:%M %P').strip

      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy

      # Recalled referral displays in recalled referrals dasboard table
      recalled_from = 'Yale'
      service_type = 'Disability Benefits'
      closed_by = 'harvard Ivy'

      recalled_referral_dashboard.go_to_recalled_referrals_dashboard
      expect(recalled_referral_dashboard.page_displayed?).to be_truthy
      expect(recalled_referral_dashboard.headers_displayed?).to be_truthy
      expect(recalled_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(recalled_from, service_type, recalled_date)

      # Navigate to recalled referral
      referral.go_to_recalled_referral_with_id(referral_id: @referral.referral_id)

      # Close referral
      close_note = Faker::Lorem.sentence(word_count: 5)
      referral.close_referral_action(note: close_note)

      # Navigate to closed referral
      referral.go_to_closed_referral_with_id(referral_id: @referral.referral_id)

      # Referral is correctly updated
      expect(referral.status).to eql(referral.class::CLOSED_STATUS)
      expect(referral.outcome_notes).to eql(close_note)
      expect(referral.action_btn_text).to eql(referral.class::CLOSED_REFERRAL_ACTION)
      expect(referral.closed_by).to eql(closed_by)
    end

    it 'close a rejected referral', :uuqa_1626 do
      # Create Contact
      @contact = Setup::Data.create_yale_client_with_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_yale_to_harvard(contact_id: @contact.contact_id)

      # Reject Referral
      reject_note = Faker::Lorem.sentence(word_count: 5)
      Setup::Data.reject_referral_in_harvard(referral_id: @referral.referral_id, note: reject_note)

      log_in_as(Login::ORG_YALE)
      expect(homepage.page_displayed?).to be_truthy

      # Close Referral
      referral.go_to_rejected_referral_with_id(referral_id: @referral.referral_id)
      close_note = Faker::Lorem.sentence(word_count: 5)
      referral.close_referral_action(note: close_note)
      closed_by = 'Yale Ivy'

      # Navigate to closed referral
      referral.go_to_closed_referral_with_id(referral_id: @referral.referral_id)

      # Referral is correctly updated
      expect(referral.status).to eql(referral.class::CLOSED_STATUS)
      expect(referral.outcome_notes).to eql(close_note)
      expect(referral.action_btn_text).to eql(referral.class::CLOSED_REFERRAL_ACTION)
      expect(referral.closed_by).to eql(closed_by)
    end

    it 'close a sent referral pending consent', :uuqa_1627 do
      # Create Contact
      @contact = Setup::Data.create_yale_client

      # Create Referral
      @referral = Setup::Data.send_referral_from_yale_to_harvard(contact_id: @contact.contact_id)

      log_in_as(Login::ORG_YALE)
      expect(homepage.page_displayed?).to be_truthy

      # Referral displays in sent pending consent referrals dasboard table
      recipient = 'Harvard'
      sending = 'Yale Ivy'
      service_type = 'Disability Benefits'

      sent_pending_consent_referral_dashboard.go_to_sent_pending_consent_referrals_dashboard
      expect(sent_pending_consent_referral_dashboard.page_displayed?).to be_truthy
      expect(sent_pending_consent_referral_dashboard.headers_displayed?).to be_truthy
      expect(sent_pending_consent_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(recipient, sending, service_type)

      # Close Referral
      referral.go_to_sent_pending_consent_referral_with_id(referral_id: @referral.referral_id)
      close_note = Faker::Lorem.sentence(word_count: 5)
      referral.close_referral_action(note: close_note)

      # Navigate to closed referral
      referral.go_to_closed_referral_with_id(referral_id: @referral.referral_id)

      # Referral is correctly updated
      expect(referral.status).to eql(referral.class::CLOSED_STATUS)
      expect(referral.outcome_notes).to eql(close_note)
      expect(referral.action_btn_text).to eql(referral.class::CLOSED_REFERRAL_ACTION)
      expect(referral.closed_by).to eql(sending)
    end
  end
end
