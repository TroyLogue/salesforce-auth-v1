require_relative '../../auth/helpers/login'
require_relative '../../root/pages/right_nav'
require_relative '../../root/pages/home_page'
require_relative '../../referrals/pages/referral'
require_relative '../../referrals/pages/referral_send'
require_relative '../../referrals/pages/referral_network_map'
require_relative '../../referrals/pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:sent_referral_dashboard) { ReferralDashboard::Sent::All.new(@driver) }
  let(:referral_send) { ReferralSend.new(@driver) }

  context('[as a Referral user]') do
    before {
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(contact_id: @contact.contact_id)
    }

    it 'user can send a referral in review', :uuqa_1652 do
      # Hold referral for review
      hold_note = Faker::Lorem.sentence(word_count: 5)
      Setup::Data.hold_referral_in_princeton(note: hold_note)

      # login in as org user where referral was sent
      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy

      # Opening send referral page
      referral.go_to_in_review_referral_with_id(referral_id: @referral.id)
      referral.send_referral_action

      # Selecting an org
      expect(referral_send.page_displayed?).to be_truthy
      referral_send.select_org_in_first_dropdown
      recipient = referral_send.selected_organization
      referral_send.send_referral

      # Newly created referral should display on sent all referral dashboard with new recipient and user
      status = 'Needs Action'
      sent_by = 'Princeton Ivy'
      expect(sent_referral_dashboard.page_displayed?).to be_truthy
      expect(sent_referral_dashboard.headers_displayed?).to be_truthy
      expect(sent_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(recipient, sent_by, status, @referral.service_type)

      # On send a new referral id is created, but navigating with the old referral id redirects us to the new referral id
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      expect(referral.recipient_info).to eq(recipient)
      @referral.id = referral.current_referral_id

      # closing referral for cleanup purposes
      Setup::Data.recall_referral_in_princeton(note: 'Data cleanup')
      Setup::Data.close_referral_in_princeton(note: 'Data cleanup')
    end

    it 'user can send a rejected referral', :uuqa_1662 do
      # Reject Referral
      reject_note = Faker::Lorem.sentence(word_count: 5)
      Setup::Data.reject_referral_in_princeton(note: reject_note)

      # login in as cc user who sent referral
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy

      # Opening send referral page
      referral.go_to_rejected_referral_with_id(referral_id: @referral.id)
      referral.send_referral_action

      # Selecting an org
      expect(referral_send.page_displayed?).to be_truthy
      referral_send.select_org_in_first_dropdown
      recipient = referral_send.selected_organization
      referral_send.send_referral

      # On send a new referral id is created, but navigating with the old referral id redirects us to the new referral id
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      expect(referral.recipient_info).to eq(recipient)
      @referral.id = referral.current_referral_id

      # closing referral for cleanup purposes
      Setup::Data.recall_referral_in_harvard(note: 'Data cleanup')
      Setup::Data.close_referral_in_harvard(note: 'Data cleanup')
    end

    it 'user can send a recalled referral', :uuqa_1663 do
      # recalling referral
      recall_note = Faker::Lorem.sentence(word_count: 5)
      Setup::Data.recall_referral_in_harvard(note: recall_note)

      # login in as org user where referral was sent
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy

      # Opening send referral page
      referral.go_to_recalled_referral_with_id(referral_id: @referral.id)
      referral.send_referral_action

      # Selecting an org
      expect(referral_send.page_displayed?).to be_truthy
      referral_send.select_org_in_first_dropdown
      recipient = referral_send.selected_organization
      referral_send.send_referral

      # On send a new referral id is created, but navigating with the old referral id redirects us to the new referral id
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      expect(referral.recipient_info).to eq(recipient)
      @referral.id = referral.current_referral_id

      # closing referral for cleanup purposes
      Setup::Data.recall_referral_in_harvard(note: 'Data cleanup')
      Setup::Data.close_referral_in_harvard(note: 'Data cleanup')
    end
  end
end
