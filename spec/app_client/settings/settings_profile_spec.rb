require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/right_nav'
require_relative './pages/settings_profile_page'

describe '[Settings - Profile]', :settings, :app_client do
  include Login

  let(:login_email) {LoginEmail.new(@driver) }
  let(:login_password) {LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:org_profile) { Settings::OrganizationProfile.new(@driver) }
  
  context('[as cc user]') do
    before {
      log_in_as(Login::CC_HARVARD)
      org_menu.go_to_profile
      expect(org_profile.page_displayed?).to be_truthy
    }

    it 'can edit and save profile fields', :uuqa_175 do
      #each editable field makes a request to the same endpoint with different info, so we aggragate all calls and to see if any are failing
      expect(org_profile.save_all_profile_fields).to all(be_truthy)
    end

  end
end
