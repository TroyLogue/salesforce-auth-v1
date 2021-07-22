# frozen_string_literal: true

require_relative '../../root/pages/home_page'
require_relative '../../root/pages/right_nav'
require_relative '../../referrals/pages/referral'

describe '[Referrals]', :app_client, :referrals do
  let(:home_page) { HomePage.new(@driver) }
  let(:new_referral) { Referral.new(@driver) }

  context('[as a Referral user]') do
    before do
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent
      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(contact_id: @contact.contact_id)

      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_03_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'user can add and remove document on a new referral', :uuqa_134, :uuqa_136 do
      new_referral.go_to_new_referral_with_id(referral_id: @referral.id)
      @document = Faker::Alphanumeric.alpha(number: 8) + '.txt'

      new_referral.attach_document_to_referral(file_name: @document)
      expect(new_referral.document_list).to include(@document)

      new_referral.remove_document_from_referral(file_name: @document)
      expect(new_referral.no_documents?).to be_truthy
    end

    after do
      # recalling referral
      Setup::Data.recall_referral_in_harvard(note: 'Data cleanup')
    end
  end
end
