# frozen_string_literal: true

require_relative './pages/org_settings_about_page'
require_relative './pages/org_settings_edit_org_location_page'

describe '[Org Settings - Location]', :org_settings, :app_client do
  let(:org_settings_about) { OrgSettings::About.new(@driver) }
  let(:org_settings_edit_location) {OrgSettings::EditOrgLocation.new(@driver)}

  context('[as an org admin]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::SETTINGS_USER)
      org_settings_about.authenticate_and_navigate_to(token: @auth_token, path: '/organization/settings')
    end

    context('can edit and save') do
      before do
        org_settings_about.edit_first_location
        expect(org_settings_edit_location.page_displayed?).to be_truthy
      end

      it 'location name', :uuqa_2649 do
        name = Faker::Lorem.word
        org_settings_edit_location.save_name(name)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_first_location_name).to include(name)
      end

      # Mimick the solution in
      # https://github.com/unite-us/end-to-end-tests/blob/master/spec/app_client/facesheet/facesheet_profile_spec.rb#L43-L50
      # Hardcoding street address, city and state due to address validation
      # 217-221 broadway blocks are valid address. Sampling a building number each time to validate an successful
      # address update
      it 'location address', :uuqa_2649 do
        street_address = "#{Faker::Number.between(from: 217, to: 221)} Broadway"
        city = "New York"
        state = 'NY'
        org_settings_edit_location.save_address("#{street_address}, #{city}, #{state}")
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_first_location_address).to include(street_address, city, state)
      end

      it 'location address optional field', :uuqa_2649 do
        address_optional = "#{Faker::Number.between(from: 1, to: 10)} Apt"
        org_settings_edit_location.save_address_optional(address_optional)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_first_location_address).to include(address_optional)
      end

      it 'location phone', :uuqa_2649 do
        phone = Faker::Number.number(digits: 10)
        org_settings_edit_location.save_phone(phone)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_first_location_phone).to include(org_settings_about.number_to_phone_format(phone))
      end

      it 'location email', :uuqa_2649 do
        email = Faker::Internet.email
        org_settings_edit_location.save_email(email)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_first_location_email).to include(email)
      end

      it 'location hours of operation', :uuqa_2649 do
        time = "#{Faker::Number.between(from: 1, to: 10)}:00 AM"
        org_settings_edit_location.save_time(time)
        expect(org_settings_about.page_displayed?).to be_truthy
        expect(org_settings_about.get_first_location_time).to include(time)
      end
    end
  end
end
