require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative '../referrals/pages/dashboard_referral'
require_relative '../referrals/pages/dashboard_referral_send'
require_relative '../referrals/pages/dashboard_referral_network_map'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:referral) { Referral.new(@driver) }
  let(:send_referral) { SendReferral.new(@driver) }
  let(:network_map) { ReferralNetworkMap.new(@driver) }

  context('[as org user]') do
    before {
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent(token: base_page.get_uniteus_api_token)

      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(token: base_page.get_uniteus_api_token,
                                                                      contact_id: @contact.contact_id,
                                                                      service_type_id: base_page.get_uniteus_first_service_type_id)

      user_menu.log_out
      expect(login_email.page_displayed?).to be_truthy

      # login in as org user where referral was sent
      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'user can send referral using Browse map', :uuqa_48 do
      # Opening send referral page
      referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)
      referral.send_referral_action

      # Opening browse map, clearing the filter and selecting the top most organization in list
      expect(send_referral.page_displayed?).to be_truthy
      send_referral.open_network_browse_map

      expect(network_map.page_displayed?).to be_truthy
      network_map.clear_all_filters
      org_name = network_map.add_first_organization_from_list
      network_map.add_organizations_to_referral

      # Checking that the dropdown has the same org we selected in browse map
      expect(send_referral.page_displayed?).to be_truthy
      expect(send_referral.selected_organization).to eq(org_name)
      send_referral.send_referral

      # On send a new referral id is created, but navigating with the old referral id redirects us to the new referral id
      referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)
      expect(referral.recipient_info).to eq(org_name)
      @referral.referral_id = referral.current_referral_id
    end

    after {
      # recalling referral for cleanup purposes
      @resolve_referral = Setup::Data.recall_referral_in_princeton(token: base_page.get_uniteus_api_token,
                                                                   referral_id: @referral.referral_id,
                                                                   note: 'Data cleanup')
    }
  end
end
