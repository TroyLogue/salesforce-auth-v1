# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class Intake < BasePage
  # frozen_string_literal: true
  INTAKE_NAVIGATION = { css: '.intake-container__navigation' }.freeze
  INTAKE_FORM = { css: '.intake-container__content' }.freeze

  FIRSTNAME_INPUT = { css: '#first-name' }.freeze
  LASTNAME_INPUT = { css: '#last-name' }.freeze
  DOB_INPUT = { css: '#date-of-birth' }.freeze
  INTAKE_NOTES = { css: '#general-notes' }.freeze
  SUBMIT_BTN = { css: '#form-footer-submit-btn' }.freeze

  # Intake Navigation
  # Program Services
  BASIC_INFORMATION = { css: '#basic-information-nav-item' }.freeze
  CONTACT_INFORMATION = { id: 'contact-information-nav-item' }.freeze
  LOCATION_INFORMATION = { id: 'location-information-nav-item' }.freeze
  HOUSEHOLD_INFORMATION = { id: 'household-information-nav-item' }.freeze
  OTHER_INFORMATION = { id: 'other-information-nav-item' }.freeze
  MILITARY_INFORMATION = { id: 'military-information-nav-item' }.freeze
  GENERAL_NOTES = { id: 'general-notes-nav-item' }.freeze
  SERVICE_INFORMATION = { link_text: 'Service Information' }.freeze
  CARE_COORDINATOR = { id: 'care-coordinator-nav-item' }.freeze

  # Other Information fields
  MARITAL_STATUS = { css: '#marital-status + .choices__list' }.freeze
  GENDER = { css: '#gender + .choices__list' }.freeze
  RACE = { css: '#race + .choices__list' }.freeze
  ETHNICITY = { css: '#ethnicity + .choices__list' }.freeze
  CITIZENSHIP = { css: '#citizenship + .choices__list' }.freeze
  SSN_INPUT = { css: 'input#ssn' }.freeze

  # dropdown menu first options
  MARITAL_STATUS_OPTION = { id: 'choices-marital-status-item-choice-1' }.freeze
  GENDER_OPTION = { id: 'choices-gender-item-choice-2' }.freeze
  RACE_OPTION = { id: 'choices-race-item-choice-1' }.freeze
  ETHNICITY_OPTION = { id: 'choices-ethnicity-item-choice-1' }.freeze
  CITIZENSHIP_OPTION = { id: 'choices-citizenship-item-choice-3' }.freeze

  # selected options
  SELECTED_MARITAL_STATUS = { css: '#marital-status option[selected]' }.freeze
  SELECTED_GENDER = { css: '#gender option[selected]' }.freeze
  SELECTED_RACE = { css: '#race option[selected]' }.freeze
  SELECTED_ETHNICITY = { css: '#ethnicity option[selected]' }.freeze
  SELECTED_CITIZENSHIP = { css: '#citizenship option[selected]' }.freeze

  # general notes
  GENERAL_NOTES = { css: '.ui-gradient #general-notes' }.freeze

  # checkbox
  NEEDS_ACTION_CHECKBOX = { css: '#needs-action-checkbox-field + label' }.freeze

  def page_displayed?
    is_displayed?(INTAKE_NAVIGATION) &&
      is_displayed?(INTAKE_FORM)
  end

  # for now we are only looking for firstname, lastname, dob
  def is_info_prefilled?(**params)
    if params.key?(:fname) && value(FIRSTNAME_INPUT) != params[:fname]
      print "First Name value saved '#{params[:fname]}' do not equal value displayed '#{value(FIRSTNAME_INPUT)}'"
      return false
    end
    if params.key?(:lname) && value(LASTNAME_INPUT) != params[:lname]
      print "Last Name value saved '#{params[:fname]}' do not equal value displayed '#{value(LASTNAME_INPUT)}'"
      return false
    end
    if params.key?(:dob) && value(DOB_INPUT) != params[:dob]
      print "Dob value saved '#{params[:dob]}' do not equal value displayed '#{value(DOB_INPUT)}'"
      return false
    end
    true
  end

  def save_intake
    click(SUBMIT_BTN)
    wait_for_spinner
  end

  def select_other_information
    click(OTHER_INFORMATION)
  end

  def select_marital_status
    click(MARITAL_STATUS)
    click(MARITAL_STATUS_OPTION)
  end

  def select_gender
    click(GENDER)
    click(GENDER_OPTION)
  end

  def select_race
    click(RACE)
    click(RACE_OPTION)
  end

  def select_ethnicity
    click(ETHNICITY)
    click(ETHNICITY_OPTION)
  end

  def select_citzenship
    click(CITIZENSHIP)
    click(CITIZENSHIP_OPTION)
  end

  def input_ssn(ssn_number)
    click(SSN_INPUT)
    enter(ssn_number, SSN_INPUT)
  end

  def add_note(note)
    enter(note, GENERAL_NOTES)
  end

  def check_needs_action
    click(NEEDS_ACTION_CHECKBOX)
  end

  def get_text_of_first_marital_status
    puts value(SELECTED_MARITAL_STATUS).to_s
  end

  def get_text_of_first_gender
    puts value(SELECTED_GENDER).to_s
  end

  def get_text_of_first_race
    puts value(SELECTED_RACE).to_s
  end

  def get_text_of_first_ethnicity
    puts value(SELECTED_ETHNICITY).to_s
  end

  def get_text_of_first_citizenship
    puts value(SELECTED_CITIZENSHIP).to_s
  end

  def get_text_of_ssn
    puts value(SSN_INPUT).to_s
  end

  def get_text_of_note
    puts text(GENERAL_NOTES).to_s
  end
end
