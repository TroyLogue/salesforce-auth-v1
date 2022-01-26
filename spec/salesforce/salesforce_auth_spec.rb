require_relative '../shared_components/base_page'
require_relative './pages/salesforce_auth_page'
require_relative './pages/salesforce_landing_page'
require_relative './pages/uu_dashboard_context_page'
require_relative './pages/uu_patient_context_page'
require_relative './pages/salesforce_verification_page'
require_relative '../app_client/auth/helpers/login'


RSpec.describe 'Salesforce v1: Authentication and Authorization' do
  #Here we are instantiating the pages we are going to interact with.
  let(:salesforce_auth_page){SalesforceAuthPage.new(@driver)}
  let(:salesforce_verification_page){SalesforceVerificationPage.new(@driver)}
  let(:salesforce_landing_page) { SalesforceLandingPage.new(@driver)}
  let(:uu_patient_page) { UuPatientContextPage.new(@driver)}
  let(:uu_dashboard_page) { UuDashboardContextPage.new(@driver)}

  context 'Patient context authentication:' do

    it 'Requires the user to first be authenticated in Salesforce' do
        #salesforce login page
        salesforce_auth_page.navigate_to_salesforce
        expect(salesforce_auth_page.auth_page_displayed?).to be_truthy
        salesforce_auth_page.enter_credentials
        salesforce_auth_page.check_remember_me
        sleep 5
        salesforce_auth_page.click_login
        #salesforce code verification page
        if salesforce_verification_page.verification_page_display?
        salesforce_verification_page.enter_code
        salesforce_verification_page.click_login
        sleep 5
        else
        expect(salesforce_landing_page.page_displayed?).to be_truthy
        sleep 3
        end
    end
    it 'Requires the user to send a signed request POST to the Unite Us auth application by clicking on a link or UU logo.'
    it 'Requires UU Auth to validate the username and base/launch URL against the user records in the Auth database.'
    it 'Requires UU Auth to create a user access token containing all information required by the EMR application.'
    it 'Requires UU Auth to redirect the user to the EMR application Patient page/view.'
  end

  context 'Failed Patient context authentication:' do
    it 'Requires the user to first be authenticated in Salesforce'
    it 'Requires the user to send a signed request POST to the Unite Us auth application by clicking on a link or UU logo.'
    it 'Requires UU auth to validate the username and base/launch URL against the user records in the Auth database.'
    it 'Returns an error message if UU auth fails to validated username and base/launch URL  (or generate user access token).'
    it 'Does not redirect the user to the EMR application Patient page/view.'
  end

  context 'Dashboard context authentication:' do
    it 'Requires the user to first be authenticated in Salesforce'

    it 'Requires the user to send a signed request POST to the Unite Us auth application by clicking on a link or UU logo.'
    it 'Requires UU auth to validate the username and base/launch URL against the user records in the Auth database.'
    it 'Returns an error message if UU auth fails to validated username and base/launch URL  (or generate user access token).'
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