require_relative '../../auth/helpers/login'
require_relative '../../root/pages/right_nav'
require_relative '../../root/pages/home_page'
require_relative '../../referrals/pages/referral'
require_relative '../../referrals/pages/referral_dashboard'
require_relative '../../consent/pages/pending_consent_page'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:pending_consent_page) { PendingConsentPage.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:recalled_referral_dashboard) { ReferralDashboard::Recalled.new(@driver) }
  let(:sent_pending_consent_referral_dashboard) { ReferralDashboard::Sent::PendingConsent.new(@driver) }
  let(:p2p_referral_dashboard) { ReferralDashboard::ProviderToProvider.new(@driver) }
  let(:closed_referral_dashboard) { ReferralDashboard::Closed.new(@driver) }

  context('[a cc user]') do
    it 'close a provider to provider referral', :uuqa_1625 do
      # Create Contact
      @contact = Setup::Data.create_yale_client_with_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_yale_to_princeton(contact_id: @contact.contact_id)

      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy

      # Referral displays in p2p referrals dasboard table
      status = 'Needs Action'

      p2p_referral_dashboard.go_to_p2p_referrals_dashboard
      expect(p2p_referral_dashboard.page_displayed?).to be_truthy
      expect(p2p_referral_dashboard.headers_displayed?).to be_truthy
      expect(p2p_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(@referral.received_org, @referral.sent_org, @referral.service_type, status)

      # Navigate to p2p referral
      referral.go_to_recalled_referral_with_id(referral_id: @referral.id)

      # Close referral, only option available
      close_note = Faker::Lorem.sentence(word_count: 5)
      closed_by = 'harvard Ivy'
      referral.close_referral_through_btn(note: close_note)

      # Navigate to closed referral
      referral.go_to_closed_referral_with_id(referral_id: @referral.id)

      # Referral is correctly updated
      expect(referral.status).to eql(referral.class::CLOSED_STATUS)
      expect(referral.outcome_notes).to eql(close_note)
      expect(referral.action_btn_text).to eql(referral.class::CLOSED_REFERRAL_ACTION)
      expect(referral.closed_by).to eql(closed_by)
    end
  end

  context('[as a Referral Admin user]') do
    it 'close a recalled referral', :uuqa_1578 do
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_yale(contact_id: @contact.contact_id)

      # Recall Referral
      recall_note = 'Recalling Referral'
      Setup::Data.recall_referral_in_harvard(note: recall_note)

      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy

      # Recalled referral displays in recalled referrals dasboard table
      recalled_referral_dashboard.go_to_recalled_referrals_dashboard

      expect(recalled_referral_dashboard.page_displayed?).to be_truthy
      expect(recalled_referral_dashboard.headers_displayed?).to be_truthy
      expect(recalled_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(@referral.received_org, @referral.service_type)

      # Navigate to recalled referral
      referral.go_to_recalled_referral_with_id(referral_id: @referral.id)

      # Close referral
      closed_by = 'harvard Ivy'
      close_note = Faker::Lorem.sentence(word_count: 5)
      referral.close_referral_action(note: close_note)

      # Navigate to closed referral
      referral.go_to_closed_referral_with_id(referral_id: @referral.id)

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
      Setup::Data.reject_referral_in_harvard(note: reject_note)

      log_in_as(Login::ORG_YALE)
      expect(homepage.page_displayed?).to be_truthy

      # Close Referral
      referral.go_to_rejected_referral_with_id(referral_id: @referral.id)
      close_note = Faker::Lorem.sentence(word_count: 5)
      referral.close_referral_action(note: close_note)
      closed_by = 'Yale Ivy'

      # Navigate to closed referral
      referral.go_to_closed_referral_with_id(referral_id: @referral.id)

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
      sent_pending_consent_referral_dashboard.go_to_sent_pending_consent_referrals_dashboard
      expect(sent_pending_consent_referral_dashboard.page_displayed?).to be_truthy
      expect(sent_pending_consent_referral_dashboard.headers_displayed?).to be_truthy
      expect(sent_pending_consent_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(@referral.received_org, @referral.sent_by, @referral.service_type)

      # Close Referral
      referral.go_to_sent_pending_consent_referral_with_id(referral_id: @referral.id)
      close_note = Faker::Lorem.sentence(word_count: 5)
      referral.close_referral_action(note: close_note)
      closed_by = 'Yale Ivy'

      # Navigate to closed referral
      referral.go_to_closed_referral_with_id(referral_id: @referral.id)

      # Referral is correctly updated
      expect(referral.status).to eql(referral.class::CLOSED_STATUS)
      expect(referral.outcome_notes).to eql(close_note)
      expect(referral.action_btn_text).to eql(referral.class::CLOSED_REFERRAL_ACTION)
      expect(referral.closed_by).to eql(closed_by)
    end

    it 'close a referral in review', :uuqa_1650 do
      # Create Contact
      @contact = Setup::Data.create_yale_client_with_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_yale_to_harvard(contact_id: @contact.contact_id)

      # Hold Referral
      hold_note = Faker::Lorem.sentence(word_count: 5)
      Setup::Data.hold_referral_in_harvard(note: hold_note)

      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy

      # Close Referral
      referral.go_to_in_review_referral_with_id(referral_id: @referral.id)
      close_note = Faker::Lorem.sentence(word_count: 5)
      referral.close_referral_action(note: close_note)
      closed_by = 'harvard Ivy'

      # Closed referral displays in closed referrals dasboard table
      expect(closed_referral_dashboard.page_displayed?).to be_truthy
      expect(closed_referral_dashboard.headers_displayed?).to be_truthy
      expect(closed_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(@referral.received_org, @referral.service_type)

      # Navigate to closed referral
      referral.go_to_closed_referral_with_id(referral_id: @referral.id)

      # Referral is correctly updated
      expect(referral.status).to eql(referral.class::CLOSED_STATUS)
      expect(referral.outcome_notes).to eql(close_note)
      expect(referral.action_btn_text).to eql(referral.class::CLOSED_REFERRAL_ACTION)
      expect(referral.closed_by).to eql(closed_by)
    end

    it 'close an incoming referral pending consent', :uuqa_1716 do
      # create contact
      @contact = Setup::Data.create_yale_client

      # create referral
      @referral = Setup::Data.send_referral_from_yale_to_harvard(contact_id: @contact.contact_id)

      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy

      homepage.go_to_pending_consent

      expect(pending_consent_page.page_displayed?).to be_truthy
      pending_consent_page.open_first_close_referral_modal

      close_note = Faker::Lorem.sentence(word_count: 5)
      referral.submit_close_referral_modal(note: close_note)

      # Closed referral displays in closed referrals dasboard table
      expect(closed_referral_dashboard.page_displayed?).to be_truthy
      expect(closed_referral_dashboard.headers_displayed?).to be_truthy
      expect(closed_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(@referral.received_org, @referral.service_type)

      closed_referral_dashboard.click_on_row_by_client_name(client: "#{@contact.fname} #{@contact.lname}")
      expect(closed_referral_dashboard.pop_up_message).to eql(ReferralDashboard::Closed::UNAUTHORIZED_MESSAGE)
    end
  end
end
