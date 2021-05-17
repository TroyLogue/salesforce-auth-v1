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

    it 'can edit and save description', :uuqa_810 do
      description = Faker::Lorem.word
      org_settings_profile.save_description(description)
      expect(org_settings_profile.get_description).to eq(description)
    end

    it 'can edit and save phone number', :uuqa_810 do
      phone = Faker::Number.number(digits: 10)
      org_settings_profile.save_phone(phone)
      expect(org_settings_profile.get_phone).to eq(org_settings_profile.number_to_phone_format(phone))
    end

    it 'can edit and save email', :uuqa_810 do
      email = Faker::Internet.email
      org_settings_profile.save_email(email)
      expect(org_settings_profile.get_email).to eq(email)
    end

    it 'can edit and save address', :uuqa_810 do
      address = "#{Faker::Number.between(from: 1, to: 10)} Apt"
      org_settings_profile.save_address(address)
      expect(org_settings_profile.get_address).to include(address)
    end

    it 'can edit and save website', :uuqa_810 do
      weburl = Faker::Internet.url
      org_settings_profile.save_website(weburl)
      expect(org_settings_profile.get_website).to eq(weburl)
    end

    it 'can edit and save hours of operation', :uuqa_810 do
      time = "#{Faker::Number.between(from: 1, to: 10)}:00 AM"
      org_settings_profile.save_time(time)
      expect(org_settings_profile.get_time).to include(time)
    end
  end
end
