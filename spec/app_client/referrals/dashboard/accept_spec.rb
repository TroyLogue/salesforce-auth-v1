# frozen_string_literal: true

require_relative '../../root/pages/right_nav'
require_relative '../../root/pages/home_page'
require_relative '../../cases/pages/case'
require_relative '../../referrals/pages/referral'
require_relative '../../referrals/pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  let(:home_page) { HomePage.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:new_referral_dashboard) { ReferralDashboard::New.new(@driver) }
  let(:new_case) { Case.new(@driver) }

  context('[as org user]') do
    before do
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent
      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(contact_id: @contact.contact_id)
    end

    it 'user can accept a new referral and case is opened', :uuqa_1012 do
      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_PRINCETON)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      status = 'Needs Action'

      # Newly created referral should display in new referral dashboard
      new_referral_dashboard.go_to_new_referrals_dashboard
      expect(new_referral_dashboard.page_displayed?).to be_truthy
      expect(new_referral_dashboard.org_headers_displayed?).to be_truthy
      expect(new_referral_dashboard.row_values_for_client(client: "#{@contact.fname} #{@contact.lname}"))
        .to include(@referral.sent_org, status, @referral.service_type)

      referral.go_to_new_referral_with_id(referral_id: @referral.id)

      # Accept referral into a program
      referral.accept_action

      # Case is opened with correct status
      expect(new_case.page_displayed?).to be_truthy
      expect(new_case.status).to eq(new_case.class::OPEN_STATUS)

      # Referral has updated status
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      expect(referral.status).to eq(referral.class::ACCEPTED_STATUS)
    end

    it 'user can accept a referral in review and case is opened', :uuqa_1649 do
      # Hold referral for review
      hold_note = Faker::Lorem.sentence(word_count: 5)
      Setup::Data.hold_referral_in_princeton(note: hold_note)

      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_PRINCETON)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      referral.go_to_in_review_referral_with_id(referral_id: @referral.id)

      # Accept referral into a program
      referral.accept_action

      # Case is opened with correct status
      expect(new_case.page_displayed?).to be_truthy
      expect(new_case.status).to eq(new_case.class::OPEN_STATUS)

      # Referral has updated status
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      expect(referral.status).to eq(referral.class::ACCEPTED_STATUS)
    end
  end
end
