# frozen_string_literal: true

require_relative '../../auth/helpers/login'
require_relative '../../root/pages/right_nav'
require_relative '../../root/pages/home_page'
require_relative '../../facesheet/pages/facesheet_header'
require_relative '../../referrals/pages/create_referral'
require_relative '../../referrals/pages/referral_network_map'

describe '[Referrals]', :app_client, :referrals, :smoke do
  include Login

  let(:home_page) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:add_referral_page) { CreateReferral::AddReferral.new(@driver) }
  let(:network_map) { ReferralNetworkMap.new(@driver) }

  context('[as a Referrals user]') do
    context('[existing client with address]') do
      it 'view orgs based on distance of client', :uuqa_1679 do
        @contact = Setup::Data.create_harvard_client_with_consent
        @contact.add_address
        log_in_as(Login::CC_HARVARD)
        expect(home_page.page_displayed?).to be_truthy

        facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id)
        facesheet_header.refer_client
        expect(add_referral_page.page_displayed?).to be_truthy

        add_referral_page.select_first_service_type
        add_referral_page.open_network_browse_map

        expect(network_map.page_displayed?).to be_truthy
        expect(network_map.address_summary).to include(@contact.formatted_address)
      end
    end
  end
end
