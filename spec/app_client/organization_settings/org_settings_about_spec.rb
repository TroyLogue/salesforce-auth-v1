# frozen_string_literal: true

require_relative './pages/org_settings_about_page'
require_relative './pages/org_settings_edit_org_page'

describe '[Org Settings - About]', :org_settings, :app_client do
  let(:org_settings_about) { OrgSettings::About.new(@driver) }
  let(:org_settings_edit_org) {OrgSettings::EditOrgInfo.new(@driver)}

  context('[as an org admin]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::SETTINGS_USER)
      org_settings_about.authenticate_and_navigate_to(token: @auth_token, path: '/organization/settings')
    end

    it 'can see the org settings page', :uuqa_810 do
      expect(org_settings_about.page_displayed?).to be_truthy
    end

    context('can edit and save') do
      before do
        org_settings_about.edit_org_info
        expect(org_settings_edit_org.page_displayed?).to be_truthy
      end

      it 'org description', :uuqa_810 do
        description = Faker::Lorem.word
        org_settings_edit_org.save_description(description)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_description).to include(description)
      end

      it 'org website', :uuqa_810 do
        web_url = Faker::Internet.url
        org_settings_edit_org.save_website(web_url)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_website).to include(web_url)
      end

      it 'org phone', :uuqa_810 do
        phone = Faker::Number.number(digits: 10)
        org_settings_edit_org.save_phone(phone)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_phones).to include(org_settings_about.number_to_phone_format(phone))
      end

      it 'org email', :uuqa_810 do
        email = Faker::Internet.email
        org_settings_edit_org.save_email(email)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_emails).to include(email)
      end

      it 'org hours of operation', :uuqa_810 do
        time = "#{Faker::Number.between(from: 1, to: 10)}:00 AM"
        org_settings_edit_org.save_time(time)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_time).to include(time)
      end
    end
  end
end
