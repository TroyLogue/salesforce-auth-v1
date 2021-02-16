# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class NewScreeningPage < BasePage
  NEW_SCREENING_CONTAINER = { css: '.screenings-new' }
  SCREENING_STEPPER = { css: '.MuiStepper-root.MuiStepper-horizontal' }
  SEARCH_RECORDS_STEP = { css: '.MuiStepper-root.MuiStepper-horizontal > div:nth-child(1) > button' }
  CONTACT_INFO_STEP = { css: '.MuiStepper-root.MuiStepper-horizontal > div:nth-child(2) > button' }
  CLIENT_SCREENING_STEP = { css: '.MuiStepper-root.MuiStepper-horizontal > div:nth-child(3) > button' }

  SELECT_SCREENING_DROPDOWN = { css: '.screening-form-select .choices' }
  SELECT_NETWORK_DROPDOWN = { css: '.screening-network-form .choices' }
  SCREENING_CHOICE = { css: '.screening-form-select .choices__item' }
  NETWORK_CHOICE = { css: '.screening-network-form .choices__item'}

  #step 1 search records
  FIRST_NAME = { id: 'first-name' }
  LAST_NAME = { id: 'last-name' }
  DOB = { id: 'date-of-birth' }
  SEARCH_RECORDS_BTN = { id: 'search-records-btn' }

  def search_records(fname, lname, dob)
    enter(fname, FIRST_NAME)
    enter(lname, LAST_NAME)
    enter(dob, DOB)
    click(SEARCH_RECORDS_BTN)
  end

  #step 2 contact information
  GO_BACK_BTN = { id: 'go-back-btn' }
  SAVE_AND_CONTINUE_BTN = { id: 'save-and-continue-btn' }

  HELP_BLOCK = { class: 'help-block' }
  CLIENT_NOT_FOUND_MESSAGE = "We did not find your client in our records. Please fill out your client's basic contact information below."

  #required fields
  GENDER = { css: '#gender + .choices__list' }.freeze
  MARITAL_STATUS = { css: '#marital-status + .choices__list' }.freeze
  RACE = { css: '#race + .choices__list' }.freeze
  ETHNICITY = { css: '#ethnicity + .choices__list' }.freeze

  # dropdown menu first options
  GENDER_FIRST_OPTION = { id: 'choices-gender-item-choice-2' }
  MARITAL_STATUS_FIRST_OPTION = { id: 'choices-marital-status-item-choice-1' }
  RACE_FIRST_OPTION = { id: 'choices-race-item-choice-1' }
  ETHNICITY_FIRST_OPTION = { id: 'choices-ethnicity-item-choice-1' }

  SAVE_CLIENT_BUTTON = { id: 'save-client-btn' }

  def answer_required_fields
    click(GENDER)
    click(GENDER_FIRST_OPTION)
    click(MARITAL_STATUS)
    click(MARITAL_STATUS_FIRST_OPTION)
    click(RACE)
    click(RACE_FIRST_OPTION)
    click(ETHNICITY)
    click(ETHNICITY_FIRST_OPTION)
  end

  def save_client
    click(SAVE_CLIENT_BUTTON)
  end

  def client_not_found_message_displayed?
    is_displayed?(HELP_BLOCK) &&
      text(HELP_BLOCK) == CLIENT_NOT_FOUND_MESSAGE
  end

  #step 3 client screening
  SCREENING_FORM_SELECT = { class: 'screening-form-select'}
  CLIENT_SCREENING_NAME = { css: '.screening-form-name.mb-one' }
  SCREENING_NETWORK_SELECT = { xpath: '//div[@class="screening-network-form"]/descendant::div[@class="choices"]' }
  CLIENT_SCREENING_FORM = { class: 'screening-form' }
  SUBMIT_SCREENING_BTN = { xpath: '//div[@class="screening-new-form__actions text-right"]/button' }

  NO_NEED_FOR_RESOURCES_MESSAGE = "Thank You! It does not appear you need any community resources at this time. If things change, you may always call 2-1-1. 2-1-1 is a free and confidential service that helps Hoosiers across Indiana find the local resources they need. They are open 24 hours a day, 7 days a week."

  SKIP_CONSENT_LINK = { id: 'skip-consent-link' }

  def page_displayed?
    wait_for_spinner
    is_displayed?(NEW_SCREENING_CONTAINER) &&
      is_displayed?(SCREENING_STEPPER)
  end

  def client_screening_form_displayed?
    is_displayed?(CLIENT_SCREENING_NAME) &&
      is_displayed?(CLIENT_SCREENING_FORM) &&
      is_displayed?(SUBMIT_SCREENING_BTN)
  end

  def screening_form_select_displayed?
    is_displayed?(SCREENING_FORM_SELECT)
  end

  def screening_network_select_displayed?
    is_displayed?(SCREENING_NETWORK_SELECT)
  end

  # Specific to SCREENING TEST
  SCREENING_TEST_Q1 = { xpath: '//div[@class="ui-form-renderer-question"][1]/descendant::div[@class="choices"]'}
  SCREENING_TEST_Q1_ALL = { xpath: '//div[@class="ui-form-renderer-question"][1]/descendant::div[@class="choices__list"]/div[1]' }
  SCREENING_TEST_Q1_NONE = { xpath: '//div[@class="ui-form-renderer-question"][1]/descendant::div[@class="choices__list"]/div[2]' }

  # Specific to PREPARE SCREENING
  PREPARE_SCREENING_Q1 = { xpath: '//div[@class="ui-form-renderer-section"][1]/descendant::div[@class="choices"]'}
  PREPARE_SCREENING_Q1_NO = { xpath: '//div[@class="ui-form-renderer-section"][1]/descendant::div[@class="choices__list"]/div[1]' }
  PREPARE_SCREENING_Q1_YES = { xpath: '//div[@class="ui-form-renderer-section"][1]/descendant::div[@class="choices__list"]/div[2]' }
  PREPARE_SCREENING_Q1_LABEL = { xpath:  '//div[@class="ui-form-renderer-section"][1]/descendant::div[@class="ui-form-renderer-question-display__label"]' }

  def refuse_to_fill_our_screening
    click(PREPARE_SCREENING_Q1)
    click(PREPARE_SCREENING_Q1_NO)
  end

  def no_resources_needed_message_displayed?
    is_displayed?(PREPARE_SCREENING_Q1_LABEL)
    raise "E2E Error: Expect #{NO_NEED_FOR_RESOURCES_MESSAGE}. Got #{text(PREPARE_SCREENING_Q1_LABEL)}" unless NO_NEED_FOR_RESOURCES_MESSAGE == text(PREPARE_SCREENING_Q1_LABEL)
    true
  end

  def complete_screening_test_with_no_referral_needs
    click(SCREENING_TEST_Q1)
    click(SCREENING_TEST_Q1_NONE)
    submit_screening
    skip_consent_for_now if skip_consent_displayed?
  end

  def complete_screening_test_with_referral_needs
    click(SCREENING_TEST_Q1)
    click(SCREENING_TEST_Q1_ALL)
    submit_screening
    skip_consent_for_now if skip_consent_displayed?
  end

  # specific to FOOD AND HOUSING SCREENING:
  FOOD_AND_HOUSING_SCREENING = "Food and Housing Screening"
  RADIO_BTN = { css: '.ui-radio-field__item span' }

  def complete_selected_screening_with_answer(answer)
    select_screening(@selected_screening)
    select_first_network if network_dropdown_displayed?
    click_element_by_text(RADIO_BTN, answer)
    submit_screening
    skip_consent_for_now if skip_consent_displayed?
  end

  def select_first_network
    click(SELECT_NETWORK_DROPDOWN)
    click(NETWORK_CHOICE)
  end

  def submit_screening
    click(SUBMIT_SCREENING_BTN)
  end

  def select_screening(screening_name)
    @selected_screening = screening_name
    is_displayed?(SELECT_SCREENING_DROPDOWN)
    click(SELECT_SCREENING_DROPDOWN)
    click_element_by_text(SCREENING_CHOICE, @selected_screening)
    is_displayed?(SUBMIT_SCREENING_BTN)
  end

  private
  def network_dropdown_displayed?
    check_displayed?(SELECT_NETWORK_DROPDOWN)
  end

  def skip_consent_for_now
    click(SKIP_CONSENT_LINK)
  end

  def skip_consent_displayed?
    is_displayed?(SKIP_CONSENT_LINK)
  end
end
