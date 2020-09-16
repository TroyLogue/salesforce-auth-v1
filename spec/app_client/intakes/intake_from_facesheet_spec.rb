# frozen_string_literal: true

require_relative '../root/pages/notifications'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../intakes/pages/intake'
require_relative '../facesheet/pages/facesheet_forms_page'

describe '[Intake]', :app_client, :intake do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:facesheet_forms_page) { FacesheetForms.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:intake_page) { Intake.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as org user]') do
    before do
      log_in_as(Login::ORG_YALE)
      expect(home_page.page_displayed?).to be_truthy

      # Create Contact
      @contact = Setup::Data.create_yale_client_with_consent(token:
        base_page.get_uniteus_api_token)
    end

    it 'creates and saves new intake', :uuqa_81 do
      facesheet_header.go_to_facesheet_with_contact_id(
        id: @contact.contact_id,
        tab: 'forms'
      )
      expect(facesheet_header.get_facesheet_name).to eql(@contact.searchable_name)
      expect(facesheet_forms_page.page_displayed?).to be_truthy

      # create new intake from facesheet form
      facesheet_forms_page.create_new_intake
      expect(intake_page.page_displayed?).to be_truthy
      expect(intake_page.is_info_prefilled?(new_user: @contact)).to be_truthy

      # enter other information
      intake_page.select_other_information
      marital_status = intake_page.select_marital_status
      gender = intake_page.select_gender
      race = intake_page.select_race
      ethnicity = intake_page.select_ethnicity
      citizenship = intake_page.select_citzenship
      # add ssn number
      ssn_number = Faker::Number.number(digits: 9)
      intake_page.input_ssn(ssn_number)
      # add intake note
      intake_note = Faker::Lorem.sentence(word_count: 5)
      intake_page.add_note(intake_note)
      expect(intake_page.get_text_of_first_marital_status).to eq(marital_status)
      expect(intake_page.get_text_of_first_gender).to eq(gender)
      expect(intake_page.get_text_of_first_race).to eq(race)
      expect(intake_page.get_text_of_first_ethnicity).to eq(ethnicity)
      expect(intake_page.get_text_of_first_citizenship).to eq(citizenship)

      # check need action checkbox and save
      intake_page.check_needs_action
      intake_page.save_intake

      # verify green ribbon with the message "intake successfully created"
      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::INTAKE_CREATED)
      expect(facesheet_forms_page.assessments_displayed?).to be_truthy
    end
  end
end
