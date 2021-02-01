# frozen_string_literal: true

require_relative '../../auth/helpers/login'
require_relative '../../root/pages/right_nav'
require_relative '../../root/pages/home_page'
require_relative '../../root/pages/left_nav'
require_relative '../../clients/pages/clients_page'
require_relative '../../facesheet/pages/facesheet_header'
require_relative './../pages/create_referral'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:clients_page) { ClientsPage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:add_referral_page) { CreateReferral::AddReferral.new(@driver) }
  let(:open_cases_dashboard) { OpenCasesDashboard.new(@driver) }
  let(:facesheet_cases_page) { FacesheetCases.new(@driver) }
  let(:case_detail_page) { Case.new(@driver) }

  context('[as a Referral User and Referrals Out of Network User]') do
    before(:each) do
      @contact = Setup::Data.create_yale_client_with_consent
      log_in_as(Login::ORG_YALE)
      expect(homepage.page_displayed?).to be_truthy
    end

    it 'Select primary worker on OON referral', :uuqa_1633 do
      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id)
      expect(facesheet_header.page_displayed?).to be_truthy

      facesheet_header.refer_client
      expect(add_referral_page.page_displayed?).to be_truthy

      submitted_case_selections = add_referral_page.create_oon_case_selecting_first_options(description: Faker::Lorem.sentence(word_count: 5))

      expect(add_referral_page.save_button_displayed?).to be_truthy
      add_referral_page.click_save_button

      expect(open_cases_dashboard.open_cases_table_displayed?).to be_truthy

      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id, tab: 'Cases')
      facesheet_cases_page.click_first_case
      expect(case_detail_page.page_displayed?).to be_truthy
      expect(case_detail_page.primary_worker).to eq submitted_case_selections[:primary_worker]
    end
  end

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
