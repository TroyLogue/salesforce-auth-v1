# frozen_string_literal: true

require_relative '../../auth/helpers/login'
require_relative '../../root/pages/home_page'
require_relative '../../root/pages/left_nav'
require_relative '../../clients/pages/clients_page'
require_relative '../../facesheet/pages/facesheet_header'
require_relative './../pages/create_referral'
require_relative './../pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:clients_page) { ClientsPage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:add_referral_page) { CreateReferral::AddReferral.new(@driver) }

  context('[as a Referral User in sensitive org]') do
    it 'Warning displays when creating a referral', :uuqa_1678 do
      log_in_as(Login::ORG_YALE)
      expect(homepage.page_displayed?).to be_truthy

      left_nav.go_to_clients
      expect(clients_page.page_displayed?).to be_truthy
      clients_page.go_to_facesheet_second_authorized_client
      facesheet_header.refer_client

      expect(add_referral_page.page_displayed?).to be_truthy
      expect(add_referral_page.warning_info_text).to eq(
        CreateReferral::AddReferral::WARNING_REGULAR + ' ' + CreateReferral::AddReferral::WARNING_SENSITIVE
      )
    end
  end

  context('[as a Referral User in a non-sensitive org]') do
    it 'Warning displays when creating a referral', :uuqa_1678 do
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy

      left_nav.go_to_clients
      expect(clients_page.page_displayed?).to be_truthy
      clients_page.go_to_facesheet_second_authorized_client
      facesheet_header.refer_client

      expect(add_referral_page.page_displayed?).to be_truthy
      expect(add_referral_page.warning_info_text).to eq(CreateReferral::AddReferral::WARNING_REGULAR)
    end
  end
end
