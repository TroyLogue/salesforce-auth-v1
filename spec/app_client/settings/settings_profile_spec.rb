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
      log_in_as(Login::SETTINGS_USER)
      org_menu.go_to_profile
      expect(org_profile.page_displayed?).to be_truthy
    }

    it 'can edit and save profile fields', :uuqa_810 do
      # New Field Values
      description = Faker::Lorem.word
      phone = Faker::Number.number(digits: 10)
      email = Faker::Internet.email       
      address = Faker::Address.street_name
      weburl = Faker::Internet.url 
      time = "#{Faker::Number.between(from: 1, to: 10)}:00 AM"

      #Description
      org_profile.save_description(description)
      expect(org_profile.get_description).to eq(description)

      #Phone
      org_profile.save_phone(phone)
      expect(org_profile.get_phone).to eq(phone)

      #Email
      org_profile.save_email(email)
      expect(org_profile.get_email).to eq(email)

      #Address
      org_profile.save_address(address)
      expect(org_profile.get_address).to include(address)

      #Url
      org_profile.save_website(weburl)
      expect(org_profile.get_website).to eq(weburl)

      #Hours
      org_profile.save_time(time)
      expect(org_profile.get_time).to include(time)
    end

  end
end
