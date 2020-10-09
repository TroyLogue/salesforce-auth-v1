require_relative '../../../lib/state_name_abbr'
require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative './pages/facesheet_header'
require_relative './pages/facesheet_profile_page'

describe '[Facesheet][Profile]', :app_client, :facesheet do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:facesheet_profile) { FacesheetProfilePage.new(@driver) }

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_COLUMBIA)
      expect(home_page.page_displayed?).to be_truthy
      # Create Contact
      @contact = Setup::Data.create_columbia_client_with_consent
    }

    it 'User can update profile values of existing client', :uuqa_1510 do
      facesheet_header.go_to_facesheet_with_contact_id(
        id: @contact.contact_id,
        tab: 'profile'
      )

      aggregate_failures 'Updating all profile fields' do
        # Phone Number, Address, Email and Contact Preferences share the same component
        # can be removed by api-integration tests: UU3-48770
        # Update Phone Number
        @phone_number = Faker::Number.number(digits: 10)
        facesheet_profile.add_mobile_phone_number_with_enabled_notifications(phone: @phone_number)
        expect(facesheet_profile.current_phone_number).to eql(facesheet_profile.number_to_phone_format(@phone_number))

        # Update Address
        @address_line1 = Faker::Address.street_address
        @city = Faker::Address.city
        @state = Faker::Address.state
        # UU does a soft validation of addresses, therefore zip code needs to map to state
        @zip = Faker::Address.zip(state_abbreviation: state_name_to_abbr(name: @state))
        facesheet_profile.add_address(address_line1: @address_line1, city: @city, state: @state, zip: @zip)
        expect(facesheet_profile.current_address).to include(
          @address_line1, @city, state_name_to_abbr(name: @state), @zip
        )

        # Update Email
        @email = Faker::Internet.email
        facesheet_profile.add_email_with_enabled_notifications(email: @email)
        expect(facesheet_profile.current_email).to eql(@email)

        # Update Contact Preferences
        @method = facesheet_profile.class::METHOD_CONTACT_CALL
        @time = facesheet_profile.class::TIME_CONTACT_MORNING
        facesheet_profile.edit_contact_preferences(method: @method, time: @time)
        expect(facesheet_profile.current_contact_preferences).to include(@method, @time)

        # Update Name
        @fname = Faker::Name.first_name
        @lname = Faker::Name.last_name
        @mname = Faker::Name.initials(number: 1)
        @title = facesheet_profile.class::MR_TITLE
        @suffix = facesheet_profile.class::III_SUFFIX
        @nicknames = Faker::Name.middle_name
        facesheet_profile.edit_name(
          fname: @fname, lname: @lname, mname: @mname, title: @title, suffix: @suffix, nicknames: @nicknames
        )
        expect(facesheet_profile.current_name).to include(@fname, @lname, @mname, @title, @suffix, @nicknames)

        # Update DOB
        @dob = Faker::Time.backward(days: 1000)
        facesheet_profile.edit_dob(dob: @dob.strftime('%m/%d/%Y'))
        expect(facesheet_profile.current_dob).to eql(@dob.strftime('%-m/%-d/%Y'))

        # Update Citizenship
        @citizenship = facesheet_profile.class::CITIZENSHIP_US
        facesheet_profile.edit_citizenship(citizenship: @citizenship)
        expect(facesheet_profile.current_citizenship).to eql(@citizenship)

        # Update SSN
        @ssn = Faker::Number.number(digits: 9).to_s
        facesheet_profile.edit_ssn(ssn: @ssn)
        expect(facesheet_profile.current_ssn).to eql('*** - ** - ' + @ssn[-4..])

        # Update Identify As
        @gender = facesheet_profile.class::GENDER_F
        @race = facesheet_profile.class::RACE_O
        @ethnicity = facesheet_profile.class::ETHNICITY_NH_NL
        facesheet_profile.edit_identify_as(gender: @gender, race: @race, ethnicity: @ethnicity)
        expect(facesheet_profile.current_identity).to include(@gender, @race, @ethnicity)

        # Update Household
        # Count
        @total = Faker::Number.non_zero_digit.to_s
        facesheet_profile.edit_household_numerical_size(total: @total)
        expect(facesheet_profile.current_household_count).to eql(@total)

        # Marital Status
        @marital = facesheet_profile.class::MARITAL_STATUS_M_CU
        facesheet_profile.edit_marital_status(status: @marital)
        expect(facesheet_profile.current_marital_status).to eql(@marital)

        # Update Income
        @income = Faker::Number.number(digits: 5).to_s
        facesheet_profile.edit_income(income: @income)
        expect(facesheet_profile.current_income).to eql(@income)

        # Update Insurance
        @medicaid_id = Faker::Alphanumeric.alphanumeric(number: 10).upcase
        @beneficiary_id = Medicare.generate_id
        @state = Faker::Address.state
        facesheet_profile.add_insurance_section(medicaid_id: @medicaid_id, beneficiary_id: @beneficiary_id, state: @state)
        expect(facesheet_profile.current_insurance).to include(@medicaid_id, @beneficiary_id, @state)

        # Update Military status
        @affiliation = facesheet_profile.class::AFFILIATION_CAREGIVER
        facesheet_profile.edit_military_affiliation(affiliation: @affiliation)
        expect(facesheet_profile.current_military_info).to eql(@affiliation)
      end
    end
  end
end
