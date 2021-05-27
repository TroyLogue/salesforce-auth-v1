# frozen_string_literal: true

require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative './pages/org_settings_profile_page'

describe '[Org Settings - Profile]', :org_settings, :app_client do
  let(:home_page) { HomePage.new(@driver) }
  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:org_settings_profile) { OrgSettings::Profile.new(@driver) }

  context('[as an org admin]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::SETTINGS_USER)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      org_menu.go_to_profile
      expect(org_settings_profile.page_displayed?).to be_truthy
    end

    it 'can edit and save description', :uuqa_810 do
      description = Faker::Lorem.word
      org_settings_profile.save_description(description)
      # methods to clear the textarea are not reliable across browsers;
      # the delete_all_char does not work on firefox or when there are multiple lines of text;
      # other standard webdriver methods do not behave as expected.
      # which may be in part be due to the front-end component / css, e.g.,
      # using the webdriver clear function appears to clear the original text,
      # but the text is revealed to have been present on save.
      # we should revisit with the front-end rewrite; for now the test will tolerate the new description
      # being prepended to the original rather than replacing
      expect(org_settings_profile.get_description).to include(description)
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
