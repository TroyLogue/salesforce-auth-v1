# frozen_string_literal: true

require_relative '../../../lib/state_name_abbr'
require_relative '../root/pages/home_page'
require_relative './pages/facesheet_header'
require_relative './pages/facesheet_profile_page'
require_relative '../root/pages/left_nav'
require_relative '../clients/pages/clients_page'

describe '[Facesheet][Profile]', :app_client, :facesheet, :messaging do
  let(:home_page) { HomePage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:facesheet_profile) { FacesheetProfilePage.new(@driver) }

  # # option 1 - new browser session with each spec
  context('[as org user with military and insurance]') do
    before(:all) do
      @contact = Setup::Data.create_columbia_client_with_consent
    end

    before(:each) do
      auth_token = Auth.encoded_auth_token(email_address: Users::MILITARY_AND_INSURANCE_ORG)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      facesheet_header.go_to_facesheet_with_contact_id(
        id: @contact.contact_id,
        tab: 'profile'
      )
    end

    # Phone Number, Address, Email and Contact Preferences share the same component
    # can be removed by api-integration tests: UU3-48770
    it 'updates phone number', :uuqa_1510, :uuqa_290 do
      @phone_number = Faker::Number.number(digits: 10)
      facesheet_profile.add_mobile_phone_number_with_enabled_notifications(phone: @phone_number)
      expect(facesheet_profile.current_phone_number).to eql(facesheet_profile.number_to_phone_format(@phone_number))
      expect(facesheet_profile.are_phone_notifications_enabled?).to be_truthy
    end

    it 'updates address', :uuqa_1510 do
      @city = Faker::Address.city
      @state = Faker::Address.state
      # UU does a soft validation of addresses, therefore zip code needs to map to state
      @zip = Faker::Address.zip(state_abbreviation: state_name_to_abbr(name: @state))
      facesheet_profile.add_address(address_line1: @address_line1, city: @city, state: @state, zip: @zip)
      expect(facesheet_profile.current_address).to include(
        @city, state_name_to_abbr(name: @state), @zip
      )
    end

    it 'updates email address', :uuqa_1510, :uuqa_290 do
      @email = Faker::Internet.email
      facesheet_profile.add_email_with_enabled_notifications(email: @email)
      expect(facesheet_profile.current_email).to eql(@email)
      expect(facesheet_profile.are_email_notifications_enabled?).to be_truthy
    end

    it 'updates contact preferences', :uuqa_1510 do
      @method = facesheet_profile.class::METHOD_CONTACT_CALL
      @time = facesheet_profile.class::TIME_CONTACT_MORNING
      facesheet_profile.edit_contact_preferences(method: @method, time: @time)
      expect(facesheet_profile.current_contact_preferences).to include(@method, @time)
    end

    it 'updates name', :uuqa_1510 do
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
    end

    it 'updates date of birth', :uuqa_1510 do
      @dob = Faker::Time.backward(days: 1000)
      facesheet_profile.edit_dob(dob: @dob.strftime('%m/%d/%Y'))
      expect(facesheet_profile.current_dob).to eql(@dob.strftime('%-m/%-d/%Y'))
    end

    it 'updates citizenship', :uuqa_1510 do
      @citizenship = facesheet_profile.class::CITIZENSHIP_US
      facesheet_profile.edit_citizenship(citizenship: @citizenship)
      expect(facesheet_profile.current_citizenship).to eql(@citizenship)
    end

    it 'updates SSN', :uuqa_1510 do
      @ssn = Faker::Number.number(digits: 9).to_s
      facesheet_profile.edit_ssn(ssn: @ssn)
      expect(facesheet_profile.current_ssn).to eql('*** - ** - ' + @ssn[-4..])
    end

    it 'updates gender, race, and ethnicity', :uuqa_1510 do
      @gender = facesheet_profile.class::GENDER_F
      @race = facesheet_profile.class::RACE_O
      @ethnicity = facesheet_profile.class::ETHNICITY_NH_NL
      facesheet_profile.edit_identify_as(gender: @gender, race: @race, ethnicity: @ethnicity)
      expect(facesheet_profile.current_identity).to include(@gender, @race, @ethnicity)
    end

    it 'updates household count', :uuqa_1510 do
      @total = Faker::Number.non_zero_digit.to_s
      facesheet_profile.edit_household_numerical_size(total: @total)
      expect(facesheet_profile.current_household_count).to eql(@total)
    end

    it 'updates marital status', :uuqa_1510 do
      @marital = facesheet_profile.class::MARITAL_STATUS_M_CU
      facesheet_profile.edit_marital_status(status: @marital)
      expect(facesheet_profile.current_marital_status).to eql(@marital)
    end

    it 'updates income', :uuqa_1510 do
      @income = Faker::Number.number(digits: 5).to_s
      facesheet_profile.edit_income(income: @income)
      expect(facesheet_profile.current_income).to eql(@income)
    end

    it 'updates insurance', :uuqa_1510 do
      @plan_type = facesheet_profile.class::MEDICARE_PLAN
      @plan = facesheet_profile.class::MEDICARE_PLAN
      @member_id = Medicare.generate_id
      facesheet_profile.add_insurance(plan_type: @plan_type,
                                      insurance_plan: @plan,
                                      member_id: @member_id)
      expect(facesheet_profile.list_insurances).to include(@plan_type, @plan, @member_id)
    end

    it 'updates military status', :uuqa_1510 do
      @affiliation = facesheet_profile.class::AFFILIATION_CAREGIVER
      facesheet_profile.edit_military_affiliation(affiliation: @affiliation)
      expect(facesheet_profile.current_military_info).to eql(@affiliation)
    end
  end

  context('[as non-military and non-insurance focused org]') do
    let(:left_nav) { LeftNav.new(@driver) }
    let(:clients_page) { ClientsPage.new(@driver) }

    before do
      auth_token = Auth.encoded_auth_token(email_address: Users::NON_MILITARY_NON_INSURANCE_ORG)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      # Navigate to any existing contact's profile
      left_nav.go_to_clients
      expect(clients_page.page_displayed?).to be_truthy
      clients_page.go_to_facesheet_second_authorized_client
      expect(facesheet_header.page_displayed?).to be_truthy

      facesheet_header.go_to_profile
    end

    it 'insurance profile section does not display', :uuqa_1560 do
      expect(facesheet_profile.is_insurance_displayed?).to be_falsey
    end

    it 'military profile section does not display', :uuqa_1559 do
      expect(facesheet_profile.is_military_displayed?).to be_falsey
    end
  end
end
