# frozen_string_literal: true

require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative './pages/org_settings_about_page'
require_relative './pages/org_settings_edit_org_page'

describe '[Org Settings - About]', :new_org_settings, :app_client do
  let(:home_page) { HomePage.new(@driver) }
  let(:org_menu) { RightNav::OrgMenu.new(@driver) }
  let(:org_settings_about) { OrgSettings::About.new(@driver) }
  let(:org_settings_edit_org) {OrgSettings::EditOrgInfo.new(@driver)}

  context('[As an org admin with access to new org settings page') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::SETTINGS_USER)
      organization_settings.authenticate_and_navigate_to(token: @auth_token, path: '/organization/settings')
    end

    it 'can see the new org settings page' do
      expect(org_settings_about.page_displayed?).to be_truthy
    end

    context('can edit and save') do
      before do
        org_settings_about.edit_org_info
        byebug
        expect(org_settings_edit_org.page_displayed?).to be_truthy
      end

      it 'org description' do
        description = Faker::Lorem.word
        org_settings_edit_org.save_description(description)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_description).to include(description)
      end

      it 'org website' do
        web_url = Faker::Internet.url
        org_settings_edit_org.save_website(web_url)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_website).to include(web_url)
      end

      it 'org phone' do
        phone = Faker::Number.number(digits: 10)
        org_settings_edit_org.save_phone(phone)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_phones).to include(phone)
      end

      it 'org email' do
        email = Faker::Internet.email
        org_settings_edit_org.save_email(email)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_emails).to include(email)
      end

      it 'org hours of operation' do
        time = "#{Faker::Number.between(from: 1, to: 10)}:00 AM"
        org_settings_edit_org.save_time(time)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_time).to include(time)
      end
    end
  end
end
