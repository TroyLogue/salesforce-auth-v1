# frozen_string_literal: true

require_relative '../../root/pages/home_page'
require_relative '../../root/pages/left_nav'
require_relative '../../clients/pages/clients_page'
require_relative '../../facesheet/pages/facesheet_header'
require_relative './../pages/create_referral'
require_relative './../pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  let(:home_page) { HomePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:clients_page) { ClientsPage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:add_referral_page) { CreateReferral::AddReferral.new(@driver) }

  context('[as a Referral User in sensitive org]') do
    it 'Warning displays when creating a referral', :uuqa_1678 do
      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_01_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      left_nav.go_to_clients
      expect(clients_page.page_displayed?).to be_truthy

      clients_page.go_to_facesheet_second_authorized_client
      expect(facesheet_header.page_displayed?).to be_truthy

      facesheet_header.refer_client
      expect(add_referral_page.page_displayed?).to be_truthy
      expect(add_referral_page.warning_info_text).to eq(
        CreateReferral::AddReferral::WARNING_REGULAR + ' ' + CreateReferral::AddReferral::WARNING_SENSITIVE
      )
    end
  end

  context('[as a Referral User in a non-sensitive org]') do
    it 'Warning displays when creating a referral', :uuqa_1678 do
      auth_token = Auth.encoded_auth_token(email_address: Users::CC_01_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      left_nav.go_to_clients
      expect(clients_page.page_displayed?).to be_truthy

      clients_page.go_to_facesheet_second_authorized_client
      expect(facesheet_header.page_displayed?).to be_truthy

      facesheet_header.refer_client
      expect(add_referral_page.page_displayed?).to be_truthy
      expect(add_referral_page.warning_info_text).to eq(CreateReferral::AddReferral::WARNING_REGULAR)
    end
  end
end
