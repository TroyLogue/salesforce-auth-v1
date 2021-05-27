# frozen_string_literal: true

require_relative '../../root/pages/home_page'
require_relative '../../root/pages/right_nav'
require_relative '../../facesheet/pages/facesheet_header'
require_relative '../../referrals/pages/create_referral'
require_relative '../../referrals/pages/referral_network_map'

describe '[Referrals]', :app_client, :referrals do
  let(:home_page) { HomePage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:add_referral_page) { CreateReferral::AddReferral.new(@driver) }
  let(:referral_network_map) { ReferralNetworkMap.new(@driver) }

  context('[as a Referrals user]') do
    before do
      @contact = Setup::Data.create_harvard_client_with_consent
      @contact.add_address

      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    it 'view orgs based on distance of client address', :uuqa_1679, :uuqa_159 do
      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id)
      facesheet_header.refer_client
      expect(add_referral_page.page_displayed?).to be_truthy

      add_referral_page.select_first_service_type
      add_referral_page.open_network_browse_map

      expect(referral_network_map.page_displayed?).to be_truthy
      expect(referral_network_map.address_summary).to include(@contact.formatted_address)

      recipient = referral_network_map.add_first_organization_from_list
      referral_network_map.add_organizations_to_referral
      expect(add_referral_page.selected_recipient).to eq(recipient)
    end
  end
end
