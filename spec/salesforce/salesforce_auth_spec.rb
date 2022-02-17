# frozen_string_literal: true

require_relative '../shared_components/base_page'
require_relative './pages/salesforce_auth_page'
require_relative './pages/salesforce_landing_page'
require_relative './pages/uu_dashboard_context_page'
require_relative './pages/uu_patient_context_page'
require_relative './pages/salesforce_verification_page'

RSpec.describe 'Salesforce v1: Authentication and Authorization' do

  # Here we are instantiating the pages we are going to interact with in order to log into salesforce canvas.
  let(:salesforce_auth_user) { SalesforceAuthPage.new(@driver) }
  let(:salesforce_verification_page) { SalesforceVerificationPage.new(@driver) }
  let(:salesforce_landing_page) { SalesforceLandingPage.new(@driver) }
  let(:uu_patient_page) { UuPatientContextPage.new(@driver) }
  let(:uu_dashboard_page) { UuDashboardContextPage.new(@driver) }

  context 'Patient context authentication:' do

    it 'Requires the user to first be authenticated in Salesforce' do
      # steps to enter user name and password in salesforce
      salesforce_auth_user.go_to_salesforce_base_url
      expect(salesforce_auth_user.auth_page_displayed?).to be_truthy
      salesforce_auth_user.enter_credentials
      salesforce_auth_user.check_remember_me
      salesforce_auth_user.click_login
      # steps to enter verification code to log into salesforce
      expect(salesforce_verification_page.verification_page_display?).to be_truthy
      salesforce_verification_page.code_present?
      salesforce_verification_page.click_login
      expect(salesforce_landing_page.page_displayed?).to be_truthy
      sleep 15

    end
    it 'Requires the user to send a signed request POST to the Unite Us auth application by clicking on a link/logo.'
    it 'Requires UU Auth to validate the username and base/launch URL against the user records in the Auth database.'
    it 'Requires UU Auth to create a user access token containing all information required by the EMR application.'
    it 'Requires UU Auth to redirect the user to the EMR application Patient page/view.'
  end

  context 'Failed Patient context authentication:' do
    it 'Requires the user to first be authenticated in Salesforce'
    it 'Requires the user to send a signed request POST to the Unite Us auth application by clicking on a link/logo.'
    it 'Requires UU auth to validate the username and base/launch URL against the user records in the Auth database.'
    it 'Returns an error message if UU auth fails to validated username and base/launch URL.'
    it 'Does not redirect the user to the EMR application Patient page/view.'
  end

  context 'Dashboard context authentication:' do
    it 'Requires the user to first be authenticated in Salesforce'

    it 'Requires the user to send a signed request POST to the Unite Us auth application by clicking on a link/logo.'
    it 'Requires UU auth to validate the username and base/launch URL against the user records in the Auth database.'
    it 'Returns an error message if UU auth fails to validated username and base/launch URL.'
    it 'Does not redirect the user to the EMR application Dashboard.'
  end

  context 'Failed Dashboard context authentication:' do
    it 'Is not applicable - N/A'
  end

  context 'Patient context exclusions' do
    it 'Is not applicable - N/A'
  end

  context 'Dashboard context exclusions' do
    it 'Is not applicable - N/A'
  end
end
