# frozen_string_literal: true

require_relative '../cases/pages/create_case'
require_relative '../facesheet/pages/facesheet_cases_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../referrals/pages/referral_network_map'

describe '[cases]', :app_client, :cases do
  let(:create_case) { CreateCase.new(@driver) }
  let(:facesheet_cases_page) { FacesheetCases.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:network_map) { ReferralNetworkMap.new(@driver) }

  context('[as cc user]') do
    before do
      @contact = Setup::Data.create_harvard_client_with_consent

      @auth_token = Auth.encoded_auth_token(email_address: Users::CC_USER)
      cases_path = facesheet_header.path(contact_id: @contact.contact_id, tab: 'cases')
      facesheet_header.authenticate_and_navigate_to(token: @auth_token, path: cases_path)
      expect(facesheet_cases_page.page_displayed?).to be_truthy
    end

    it 'adds OON org using Browse Map', :uuqa_1443 do
      facesheet_cases_page.create_new_case
      expect(create_case.page_displayed?).to be_truthy
      expect(create_case.is_oon_program_auto_selected?).to be_truthy

      # add an org via browse map, then remove
      create_case.select_service_type(Services::BENEFITS_DISABILITY_BENEFITS)
      create_case.browse_map
      expect(network_map.page_displayed?).to be_truthy
      first_org = network_map.add_first_organization_from_list
      network_map.add_organizations_to_referral
      expect(create_case.selected_oon_org).to eq(first_org)

      create_case.remove_first_selected_group
      expect(create_case.selected_oon_org).to eq('Choose an organization');
    end
  end
end
