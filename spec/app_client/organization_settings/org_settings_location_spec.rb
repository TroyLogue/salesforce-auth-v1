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

      # TODO needs to figure out a STABLE way to handle address input + validation
      # 1st option: use Faker::Address.full_address
      # The full_address Faker provides is not always a valid US address,
      # plus sometimes it provides a Suite or Building # that is not supposed to
      # be in the address line (our suite/building/apt # goes to address optional field).
      # 2nd option: Faker::Address.full_address_as_hash(:street_address, street_address: {include_secondary: false})
      # Using the street_address only also has the possibility of having an invalid US address,
      # plus sometimes google places will return multiple results that are slightly different from the street_address input
      # it 'location address', :uuqa_2649 do
      # end

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
