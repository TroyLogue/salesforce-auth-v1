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

    it 'creates and saves new intake', :uuqa_81, :uuqa_77 do
      facesheet_header.go_to_facesheet_with_contact_id(
        id: @contact.contact_id,
        tab: 'forms'
      )
      expect(facesheet_header.get_facesheet_name).to eql(@contact.searchable_name)
      expect(facesheet_forms_page.page_displayed?).to be_truthy

      # create new intake from facesheet form
      facesheet_forms_page.create_new_intake
      expect(intake_page.page_displayed?).to be_truthy
      # Basic info is prefilled
      expect(intake_page.is_info_prefilled?(
               fname: @contact.fname,
               lname: @contact.lname,
               dob: @contact.dob_formatted
             )).to be_truthy

      # enter other information
      intake_page.select_other_information
      intake_page.select_marital_status_first_option
      intake_page.select_gender_first_option
      intake_page.select_race_first_option
      intake_page.select_ethnicity_first_option
      intake_page.select_citzenship_first_option
      # Generate a valid US Social Security number
      ssn_number = Faker::IDNumber.valid
      intake_page.input_ssn(ssn_number)
      # add intake note
      intake_note = Faker::Lorem.sentence(word_count: 5)
      intake_page.add_note(intake_note)
      marital_status = intake_page.get_text_of_selected_marital_status
      gender = intake_page.get_text_of_selected_gender
      race = intake_page.get_text_of_selected_race
      ethnicity = intake_page.get_text_of_selected_ethnicity
      citizenship = intake_page.get_text_of_selected_citizenship

      # check need action checkbox and save
      intake_page.check_needs_action
      intake_page.save_intake

      # verify green ribbon with the message "intake successfully created"
      notification_text = notifications.success_text
      expect(notification_text).to include(Notifications::INTAKE_CREATED)
      expect(facesheet_forms_page.assessments_displayed?).to be_truthy
      # verify selected and inputted other information display
      facesheet_forms_page.view_intake
      expect(intake_page.other_information_displayed?).to be_truthy
      expect(intake_page.selected_options_saved?(marital_status: marital_status, gender: gender, race: race, ethnicity: ethnicity, citizenship: citizenship)).to be_truthy
    end
  end
end
  