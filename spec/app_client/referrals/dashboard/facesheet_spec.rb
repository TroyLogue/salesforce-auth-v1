# frozen_string_literal: true

require_relative '../../root/pages/home_page'
require_relative '../../intakes/pages/intake'
require_relative '../../referrals/pages/referral'
require_relative '../../referrals/pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  let(:home_page) { HomePage.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:intake) { Intake.new(@driver) }
  let(:new_referral_dashboard) { ReferralDashboard::New.new(@driver) }

  context('[as an Intakes user]') do
    before do
      # Create Contact
      @contact = Setup::Data.create_yale_client_with_consent
      # Create Referral
      @referral = Setup::Data.send_referral_from_yale_to_harvard(contact_id: @contact.contact_id)

      # Add Intake to Client
      @intake = Setup::Data.create_intake_for_harvard(
        contact_id: @contact.contact_id,
        fname: @contact.fname,
        lname: @contact.lname,
        dob: @contact.dob
      )

      auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'view existing intake on referral for client', :uuqa_1738 do
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      expect(referral.is_intake_link_displayed?).to be_truthy
      referral.click_view_intake_link
      expect(intake.page_displayed?).to be_truthy
    end
  end
end
