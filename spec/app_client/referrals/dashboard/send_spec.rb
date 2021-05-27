require_relative '../../root/pages/right_nav'
require_relative '../../root/pages/home_page'
require_relative '../../referrals/pages/referral'
require_relative '../../referrals/pages/referral_send'
require_relative '../../referrals/pages/referral_network_map'
require_relative '../../referrals/pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  let(:home_page) { HomePage.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:sent_referral_dashboard) { ReferralDashboard::Sent::All.new(@driver) }
  let(:draft_referral_dashboard) { ReferralDashboard::Draft.new(@driver) }
  let(:referral_send) { ReferralSend.new(@driver) }

  context('[as a Referral user with a received referral]') do
    before do
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent
      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(contact_id: @contact.contact_id)

      # login in as org user where referral was sent
      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_PRINCETON)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'user can send a referral in review', :uuqa_1652 do
      # Hold referral for review
      hold_note = Faker::Lorem.sentence(word_count: 5)
      Setup::Data.hold_referral_in_princeton(note: hold_note)

      # Opening send referral page
      referral.go_to_in_review_referral_with_id(referral_id: @referral.id)
      referral.send_referral_action

      # Selecting an org
      expect(referral_send.page_displayed?).to be_truthy
      recipient = referral_send.select_first_org
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
  end

  context('[as a Referral user with a sent referral]') do
    before do
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent
      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(contact_id: @contact.contact_id)

      # login in as cc user who sent referral
      auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'user can send a rejected referral', :uuqa_1662 do
      # Reject Referral
      reject_note = Faker::Lorem.sentence(word_count: 5)
      Setup::Data.reject_referral_in_princeton(note: reject_note)

      # Opening send referral page
      referral.go_to_rejected_referral_with_id(referral_id: @referral.id)
      referral.send_referral_action

      # Selecting an org
      expect(referral_send.page_displayed?).to be_truthy
      recipient = referral_send.select_first_org
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

      # Opening send referral page
      referral.go_to_recalled_referral_with_id(referral_id: @referral.id)
      referral.send_referral_action

      # Selecting an org
      expect(referral_send.page_displayed?).to be_truthy
      recipient = referral_send.select_first_org
      referral_send.send_referral

      # On send a new referral id is created, but navigating with the old referral id redirects us to the new referral id
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      expect(referral.recipient_info).to eq(recipient)
      @referral.id = referral.current_referral_id

      # closing referral for cleanup purposes
      Setup::Data.recall_referral_in_harvard(note: 'Data cleanup')
      Setup::Data.close_referral_in_harvard(note: 'Data cleanup')
    end

    it 'user can send a recalled referral to multiple recipients', :uuqa_1709 do
      # recalling referral
      recall_note = Faker::Lorem.sentence(word_count: 5)
      Setup::Data.recall_referral_in_harvard(note: recall_note)

      # Opening send referral page
      referral.go_to_recalled_referral_with_id(referral_id: @referral.id)
      referral.send_referral_action

      # Selecting multiple orgs
      num_of_recipients = 2
      expect(referral_send.page_displayed?).to be_truthy
      recipients = referral_send.add_multiple_recipients(count: num_of_recipients)
      referral_send.send_referral

      expect(sent_referral_dashboard.page_displayed?).to be_truthy
      expect(sent_referral_dashboard.headers_displayed?).to be_truthy

      # We expect rows returned to equal number of recipients
      client_referrals = sent_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}")
      expect(client_referrals.count).to eq num_of_recipients

      # Listing recipients that did not receive a referral
      unsent_recipients = recipients.reject { |r| client_referrals.join(' ').include?(r) }

      # If every recipient recieved a referral then we expect the unsent recipient list to be empty
      expect(unsent_recipients).to be_empty, "Referral was not sent to #{unsent_recipients}"
    end
  end

  context('[as a Referral user with a draft referral]') do
    before do
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent
      # Create Referral
      @draft_referral = Setup::Data.draft_referral_in_harvard(contact_id: @contact.contact_id)

      # auth as user who drafted referral
      auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'user can select a provider and send a draft referral', :uuqa_1733 do
      # Go to drafted referral
      referral.go_to_draft_referral_with_id(referral_id: @draft_referral.id)

      # add provider information and send
      referral.open_edit_referral_modal
      selected_org = referral.add_recipient_in_edit_referral_modal
      referral.save_edit_referral_modal
      referral.send_referral_action

      expect(sent_referral_dashboard.page_displayed?).to be_truthy
      expect(sent_referral_dashboard.headers_displayed?).to be_truthy

      sent_referral_dashboard.click_on_row_by_client_name(client: "#{@contact.fname} #{@contact.lname}")
      expect(referral.recipient_info).to eql(selected_org)
    end
  end
end
