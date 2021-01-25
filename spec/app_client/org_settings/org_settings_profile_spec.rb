# frozen_string_literal: true

require_relative '../auth/helpers/login'
require_relative '../root/pages/right_nav'
require_relative './pages/org_settings_profile_page'

describe '[Org Settings - Profile]', :org_settings, :app_client do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:org_settings_profile) { OrgSettings::Profile.new(@driver) }

  context('[as an org admin]') do
    before do
      log_in_as(Login::SETTINGS_USER)
      org_menu.go_to_profile
      expect(org_settings_profile.page_displayed?).to be_truthy
    end

    it 'can edit and save profile fields', :uuqa_810 do
      # New Field Values
      description = Faker::Lorem.word
      phone = Faker::Number.number(digits: 10)
      email = Faker::Internet.email
      address = "#{Faker::Number.between(from: 1, to: 10)} Apt"
      weburl = Faker::Internet.url
      time = "#{Faker::Number.between(from: 1, to: 10)}:00 AM"

      # Description
      org_settings_profile.save_description(description)
      expect(org_settings_profile.get_description).to eq(description)

      # Phone
      org_settings_profile.save_phone(phone)
      expect(org_settings_profile.get_phone).to eq(org_settings_profile.number_to_phone_format(phone))

      # Email
      org_settings_profile.save_email(email)
      expect(org_settings_profile.get_email).to eq(email)

      # Address
      org_settings_profile.save_address(address)
      expect(org_settings_profile.get_address).to include(address)

      # Url
      org_settings_profile.save_website(weburl)
      expect(org_settings_profile.get_website).to eq(weburl)

      # Hours
      org_settings_profile.save_time(time)
      expect(org_settings_profile.get_time).to include(time)
    end
  end
end
