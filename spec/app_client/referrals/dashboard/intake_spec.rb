# frozen_string_literal: true

require_relative '../../root/pages/right_nav'
require_relative '../../root/pages/home_page'
require_relative '../../referrals/pages/referral'
require_relative '../../intakes/pages/intake'

describe '[Referrals]', :app_client, :referrals do
  let(:home_page) { HomePage.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:intake) { Intake.new(@driver) }

  context('[as a Referral user]') do
    before do
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent
      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(contact_id: @contact.contact_id)

      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_PRINCETON)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'user can start an intake on a referral', :uuqa_1344 do
      referral.go_to_new_referral_with_id(referral_id: @referral.id)

      # Start intake referral into a program
      referral.start_intake_action
      expect(intake.page_displayed?).to be_truthy

      # Basic info is prefilled
      expect(intake.is_info_prefilled?(
               fname: @contact.fname,
               lname: @contact.lname,
               dob: @contact.dob_formatted
             )).to be_truthy

      # safe intake, should be redirected to referral page with the Needs Action Status
      intake.save_intake
      expect(referral.status).to eq(referral.class::NEEDS_ACTION_STATUS)
    end

    after do
      # recalling referral for cleanup purposes
      Setup::Data.recall_referral_in_harvard(note: 'Data clean up')
    end
  end
end
