# frozen_string_literal: true

require_relative '../../auth/helpers/login'
require_relative '../../root/pages/home_page'
require_relative '../../intakes/pages/intake'
require_relative '../../referrals/pages/referral'
require_relative '../../referrals/pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:intake) { Intake.new(@driver) }
  let(:new_referral_dashboard) { ReferralDashboard::New.new(@driver) }

  context('[as an Intakes user]') do
    before {
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

      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'view existing intake on referral for client', :uuqa_1738 do
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      expect(referral.is_intake_link_displayed?).to be_truthy
      referral.click_view_intake_link
      expect(intake.page_displayed?).to be_truthy
    end
  end
end
