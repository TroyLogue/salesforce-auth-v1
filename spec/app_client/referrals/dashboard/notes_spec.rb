# frozen_string_literal: true

require_relative '../../root/pages/home_page'
require_relative '../../referrals/pages/referral'

describe '[Referrals]', :app_client, :referrals do
  let(:home_page) { HomePage.new(@driver) }
  let(:referral) { Referral.new(@driver) }

  context('[as a Referral Admin user]') do
    before do
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent
      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(contact_id: @contact.contact_id)

      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_PRINCETON)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
    end

    it 'option to add interaction and other type notes is available on dashboard', :uuqa_2078, :uuqa_2079 do
      expect(referral.notes_section_displayed?).to be_truthy
    end
  end
end
