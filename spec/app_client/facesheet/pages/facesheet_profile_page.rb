# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class FacesheetProfilePage < BasePage
  FACESHEET_PROFILE = { css: '.facesheet-profile' }.freeze
  ERROR_MESSAGE = { css: '.ui-input-field--has-error .ui-form-field__error' }.freeze
  BTN_CLOSE = { css: '.dialog.open .title.title-closeable > a ' }.freeze

  BLANK_FIELD_ERROR_MESSAGE = 'Required'
  INVALID_PHONE_ERROR_MESSAGE = 'Must be at least 10 digits'
  ENABLED_NOTIFICATION_MESSAGE = '(message, notification)'

  def page_displayed?
    is_displayed?(FACESHEET_PROFILE)
  end

  def is_required_error_message_displayed?
    text(ERROR_MESSAGE) == BLANK_FIELD_ERROR_MESSAGE
  end

  def close_modal
    click(BTN_CLOSE)
  end

  # Intended to be used for cleaning up of profile fields when re-using a client
  def remove_profile_email_phone_fields_if_present
    # Phone
    click(EDIT_PHONE)
    is_displayed?(PHONE_MODAL)

    if is_present?(BTN_REMOVE_PHONE)
      click(BTN_REMOVE_PHONE)
      click(BTN_REMOVE_CONFIRM)
      wait_for_spinner
    end
    click(BTN_CLOSE)

    # Email
    click(EDIT_EMAIL)
    is_displayed?(EMAIL_MODAL)
    if is_present?(BTN_REMOVE_EMAIL)
      click(BTN_REMOVE_EMAIL)
      click(BTN_REMOVE_CONFIRM)
      wait_for_spinner
    end
    click(BTN_CLOSE)
  end

  module Phone
    CURRENT_PHONE = { css: '.phone-number-display > p > a' }.freeze
    CURRENT_PHONE_NOTIFICATION = { css: '.phone-number-display .communication-additional-info' }.freeze
    EDIT_PHONE = { css: '#edit-phone-number-btn' }.freeze
    PHONE_MODAL = { css: '#edit-phone-number-modal.dialog.open.large' }.freeze
    ADD_PHONE = { css: '#add-phone-link' }.freeze
    INPUT_PHONE = { css: 'input[id^="phoneNumber"]' }.freeze
    EXPAND_TYPE_CHOICES = { css: 'div[aria-activedescendant^="choices-phoneType"]' }.freeze
    LIST_TYPE_CHOICES = { css: 'div[id^="choices-phoneType"]' }.freeze
    PHONE_CHECKBOX_MESSAGE = { css: '.profile-phone-fields div > input[id$="message"] + label' }.freeze
    PHONE_CHECKBOX_NOTIFICATION = { css: '.profile-phone-fields div > input[id$="notification"] + label' }.freeze
    BTN_SAVE_PHONE = { css: '#edit-phone-number-save-btn' }.freeze
    BTN_REMOVE_PHONE = { css: '.remove-phone-button' }.freeze
    BTN_REMOVE_CONFIRM = { css: '.confirm-confirmation' }.freeze

    PHONE_TYPE_MOBILE = 'Mobile'
    PHONE_TYPE_HOME = 'Home'
    PHONE_TYPE_WORK = 'Work'
    PHONE_TYPE_FAX = 'Fax'
    PHONE_TYPE_UNKNOWN = 'Unknown'

    def current_phone_number
      text(CURRENT_PHONE)
    end

    def are_phone_notifications_enabled?
      text(CURRENT_PHONE_NOTIFICATION) == ENABLED_NOTIFICATION_MESSAGE
    end

    def add_mobile_phone_number_with_enabled_notifications(phone:)
      click(EDIT_PHONE)
      is_displayed?(PHONE_MODAL)
      # Adding Phone Number
      click(ADD_PHONE)
      click(INPUT_PHONE)
      enter(phone, INPUT_PHONE)
      click(EXPAND_TYPE_CHOICES)
      click_element_from_list_by_text(LIST_TYPE_CHOICES, PHONE_TYPE_MOBILE)
      # Enabling notifications
      click(PHONE_CHECKBOX_MESSAGE)
      click(PHONE_CHECKBOX_NOTIFICATION)
      # saving
      click(BTN_SAVE_PHONE)
      wait_for_spinner
      wait_for_notification_to_disappear
    end

    def enable_phone_notifications_on_blank_field
      click(EDIT_PHONE)
      is_displayed?(PHONE_MODAL)
      # Not adding phone number
      click(ADD_PHONE)
      # Enabling notifications
      click(PHONE_CHECKBOX_MESSAGE)
      click(PHONE_CHECKBOX_NOTIFICATION)
      # saving
      click(BTN_SAVE_PHONE)
    end
  end
  include Phone

  module Address
    ADDRESS_CONTENT = { css: '.address__content' }.freeze
    CURRENT_ADDRESS = { css: '.address' }.freeze
    EDIT_ADDRESS = { css: '#edit-address-btn' }.freeze
    ADDRESS_MODAL = { css: '#edit-address-modal.dialog.open.large' }.freeze
    LINK_ADD_ADDRESS = { css: '#add-address-link' }.freeze
    BTN_DELETE_ADDRESS = { css: 'a[title="Remove address"]' }.freeze
    BTN_DELETE_ADDRESS_CONFIRM = { css: '.address-remove-buttons__confirm-confirmation' }.freeze
    EXPAND_ADDRESS_TYPE_CHOICES = { css: 'select[name$="address_type"] + div' }.freeze
    LIST_ADDRESS_TYPE_CHOICES = { css: 'div[id^="choices--type"]' }.freeze
    INPUT_ADDRESS_LINE1 = { css: 'input[name$=".line_1"]' }.freeze
    INPUT_ADDRESS_LINE2 = { css: 'input[name$=".line_2"]' }.freeze
    INPUT_ADDPRES_CITY = { css: 'input[name$=".city"]' }.freeze
    EXPAND_STATE_LIST = { css: 'select[name$="state"] + div' }.freeze
    LIST_STATE_CHOICES = { css: 'div[id^="choices--state"]' }.freeze
    INPUT_ADDRESS_ZIP = { css: 'input[name$=".postal_code"]' }.freeze
    BTN_SAVE_ADDRESS = { css: '#edit-address-save-btn' }.freeze

    ADDRESS_TYPE_HOME = 'Home'
    ADDRESS_TYPE_WORK = 'Work'
    ADDRESS_TYPE_MAILING = 'Mailing'
    ADDRESS_TYPE_UNKNOWN = 'Unknown'

    def current_address
      is_displayed?(ADDRESS_CONTENT) &&
        text(CURRENT_ADDRESS)
    end

    def delete_address
      click(EDIT_ADDRESS)
      is_displayed?(ADDRESS_MODAL)
      # Deleting first address in list
      click(BTN_DELETE_ADDRESS)
      click(BTN_DELETE_ADDRESS_CONFIRM)
      click(BTN_SAVE_ADDRESS)
      wait_for_spinner
    end

    def add_address(type: ADDRESS_TYPE_HOME, address_line1: '217 Broadway', address_line2: '', city: 'New York', state: 'New York', zip: '10013')
      click(EDIT_ADDRESS)
      is_displayed?(ADDRESS_MODAL)
      # Filling out address
      click(LINK_ADD_ADDRESS)
      click(EXPAND_ADDRESS_TYPE_CHOICES)
      click_element_from_list_by_text(LIST_ADDRESS_TYPE_CHOICES, type)
      enter(address_line1, INPUT_ADDRESS_LINE1)
      enter(address_line2, INPUT_ADDRESS_LINE2)
      enter(city, INPUT_ADDPRES_CITY)
      click(EXPAND_STATE_LIST)
      click_element_from_list_by_text(LIST_STATE_CHOICES, state)
      enter(zip, INPUT_ADDRESS_ZIP)
      # Saving address
      click(BTN_SAVE_ADDRESS)
      wait_for_spinner
    end
  end
  include Address

  module Email
    CURRENT_EMAIL = { css: '.email > p > a' }.freeze
    CURRENT_EMAIL_NOTIFICATION = { css: '.email .communication-additional-info' }.freeze
    EDIT_EMAIL = { css: '#edit-email-btn' }.freeze
    EMAIL_MODAL = { css: '#edit-email-modal.dialog.open.normal' }.freeze
    ADD_EMAIL = { css: '#add-email-link' }.freeze
    INPUT_EMAIL = { css: 'input[name="emails[0].email_address"]' }.freeze
    EMAIL_CHECKBOX_MESSAGE = { css: '.inline-email-address div > input[id$="message"] + label' }.freeze
    EMAIL_CHECKBOX_NOTIFICATION = { css: '.inline-email-address  div > input[id$="notification"] + label' }.freeze
    BTN_SAVE_EMAIL = { css: '#edit-email-save-btn' }.freeze
    BTN_REMOVE_EMAIL = { css: '.remove-email-button' }.freeze

    def current_email
      text(CURRENT_EMAIL)
    end

    def are_email_notifications_enabled?
      text(CURRENT_EMAIL_NOTIFICATION) == ENABLED_NOTIFICATION_MESSAGE
    end

    def add_email_with_enabled_notifications(email:)
      click(EDIT_EMAIL)
      is_displayed?(EMAIL_MODAL)
      # Adding email
      click(ADD_EMAIL)
      enter(email, INPUT_EMAIL)
      # Enabling notifications
      click(EMAIL_CHECKBOX_MESSAGE)
      click(EMAIL_CHECKBOX_NOTIFICATION)
      # saving
      click(BTN_SAVE_EMAIL)
      wait_for_spinner
      wait_for_notification_to_disappear
    end

    def remove_email
      click(EDIT_EMAIL)
      is_displayed?(EMAIL_MODAL)
      if is_present?(BTN_REMOVE_EMAIL)
        click(BTN_REMOVE_EMAIL)
        click(BTN_REMOVE_CONFIRM)
        wait_for_spinner
      end
      click(BTN_CLOSE)
    end

    def enable_email_notifications_on_blank_field
      click(EDIT_EMAIL)
      is_displayed?(EMAIL_MODAL)
      # Not adding email
      click(ADD_EMAIL)
      # Enabling notifications
      click(EMAIL_CHECKBOX_MESSAGE)
      click(EMAIL_CHECKBOX_NOTIFICATION)
      # saving
      click(BTN_SAVE_EMAIL)
    end
  end
  include Email

  module ContactPreferrences
    CURRENT_PREFERENCES = { css: '.contact-preferences .profile-value' }.freeze
    EDIT_CONTACT_PREFERENCES = { css: '#edit-contact-preferences-btn' }.freeze
    PREFERENCES_MODAL = { css: '#edit-contact-preferences-modal.dialog.open.normal' }.freeze
    EXPAND_METHOD_CHOICES = { css: 'div[aria-activedescendant^="choices-preferred-method-of-contact-field-item-choice"]' }.freeze
    LIST_METHOD_CHOICES = { css: 'div[id^="choices-preferred-method-of-contact-field-item-choice"]' }.freeze
    EXPAND_TIME_CHOICES = { css: 'div[aria-activedescendant^="choices-best-time-to-contact-field-item-choice"]' }.freeze
    LIST_TIME_CHOICES = { css: 'div[id^="choices-best-time-to-contact-field-item-choice"]' }.freeze
    BTN_SAVE_PREFERENCES = { css: '#edit-communication-preferences-save-btn' }.freeze

    METHOD_CONTACT_CALL = 'Call'
    METHOD_CONTACT_EMAIL = 'Email'
    METHOD_CONTACT_N_P = 'No Preference'
    METHOD_CONTACT_TEXT = 'Text'

    TIME_CONTACT_ANYTIME = 'Any Time'
    TIME_CONTACT_MORNING = 'Morning'
    TIME_CONTACT_AFTERNOON = 'Afternoon'
    TIME_CONTACT_EVENING = 'Evening'

    def current_contact_preferences
      # Returns a string of both values ex: "Call Any Time"
      find_elements(CURRENT_PREFERENCES).map(&:text).join(' ')
    end

    def edit_contact_preferences(method: METHOD_CONTACT_CALL, time: TIME_CONTACT_ANYTIME)
      click(EDIT_CONTACT_PREFERENCES)
      is_displayed?(PREFERENCES_MODAL)
      # Selecting Method
      click(EXPAND_METHOD_CHOICES)
      click_element_from_list_by_text(LIST_METHOD_CHOICES, method)
      # Selecting Time
      click(EXPAND_TIME_CHOICES)
      click_element_from_list_by_text(LIST_TIME_CHOICES, time)
      # Saving
      click(BTN_SAVE_PREFERENCES)
      wait_for_spinner
    end
  end
  include ContactPreferrences

  module Name
    CURRENT_NAME = { css: '.personal-data .common-display-profile:nth-child(2) .col-sm-4 > p:nth-child(2)' }.freeze
    EDIT_NAME = { css: '#edit-personal-btn' }.freeze
    NAME_MODAL = { css: '#edit-personal-modal.dialog.open.large' }.freeze
    EXPAND_TITLE_CHOICES = { css: '#title + div' }.freeze
    LIST_TITLE_CHOICES = { css: 'div[id^="choices-title"]' }.freeze
    INPUT_FIRSTNAME = { css: '#first-name' }.freeze
    INPUT_LASTNAME = { css: '#last-name' }.freeze
    INPUT_MIDDLE_IN = { css: '#middle-initial' }.freeze
    EXPAND_SUFFIX_CHOICES = { css: '#suffix + div' }.freeze
    LIST_SUFFIX_CHOICES = { css: 'div[id^="choices-suffix"]' }.freeze
    INPUT_NICKNAMES = { css: '#nicknames' }.freeze
    BTN_SAVE_NAME = { css: '#edit-personal-save-btn' }.freeze

    MR_TITLE = 'Mr.'
    MRS_TITLE = 'Mrs.'

    III_SUFFIX = 'III'
    JR_SUFFIX = 'Jr.'

    def current_name
      find_elements(CURRENT_NAME).map(&:text).join(' ')
    end

    def edit_name(fname:, lname:, mname:, title: '', suffix: '', nicknames: '')
      click(EDIT_NAME)
      is_displayed?(NAME_MODAL)
      # Filling out name
      clear_then_enter(fname, INPUT_FIRSTNAME)
      clear_then_enter(lname, INPUT_LASTNAME)
      clear_then_enter(mname, INPUT_MIDDLE_IN)
      clear_then_enter(nicknames, INPUT_NICKNAMES)
      # Select Title
      unless title.empty?
        click(EXPAND_TITLE_CHOICES)
        click_element_from_list_by_text(LIST_TITLE_CHOICES, title)
      end
      # Select Suffix
      unless suffix.empty?
        click(EXPAND_SUFFIX_CHOICES)
        click_element_from_list_by_text(LIST_SUFFIX_CHOICES, suffix)
      end
      # Since there is no spinner, waiting for the modal to disappear
      click(BTN_SAVE_NAME)
      is_not_displayed?(NAME_MODAL)
    end
  end
  include Name

  module DOB
    CURRENT_DOB = { css: '.personal-data .common-display-profile:nth-child(3) .profile-value' }.freeze
    EDIT_DOB = { css: '#edit-dob-btn' }.freeze
    DOB_MODAL = { css: '#edit-dob-modal.dialog.open.normal' }.freeze
    INPUT_DOB = { css: 'input[name$="date_of_birth"]' }.freeze
    BTN_SAVE_DOB = { css: '#edit-dob-save-btn' }.freeze

    def current_dob
      text(CURRENT_DOB)
    end

    def edit_dob(dob:)
      click(EDIT_DOB)
      is_displayed?(EDIT_DOB)
      # Fill out dob
      clear_then_enter(dob, INPUT_DOB)
      # Since there is no spinner, waiting for the modal to disappear
      click(BTN_SAVE_DOB)
      is_not_displayed?(DOB_MODAL)
    end
  end
  include DOB

  module Citizenship
    CURRENT_CITIZENSHIP = { css: '.personal-data .common-display-profile:nth-child(4) .profile-value' }.freeze
    EDIT_CITIZENSHIP = { css: '#edit-citizen-btn' }.freeze
    CITIZENSHIP_MODAL = { css: '#edit-citizen-modal.dialog.open.large' }.freeze
    EXPAND_CITIZENSHIP_CHOICES = { css: '#citizenship + div' }.freeze
    LIST_CITIZENSHIP_CHOICES = { css: 'div[id^="choices-citizenship"]' }.freeze
    BTN_SAVE_CITIZENSHIP = { css: '#edit-citizen-save-btn' }.freeze

    CITIZENSHIP_UNDISCLOSED = 'Undisclosed'
    CITIZENSHIP_LAWRESIDENT = 'Lawful Permanent Resident'
    CITIZENSHIP_US = 'US Citizen'
    CITIZENSHIP_USNATIONAL = 'US National'
    CITIZENSHIP_OTHER = 'Other'

    def current_citizenship
      text(CURRENT_CITIZENSHIP)
    end

    def edit_citizenship(citizenship: CITIZENSHIP_UNDISCLOSED)
      click(EDIT_CITIZENSHIP)
      is_displayed?(CITIZENSHIP_MODAL)
      # Select citizenship
      click(EXPAND_CITIZENSHIP_CHOICES)
      click_element_from_list_by_text(LIST_CITIZENSHIP_CHOICES, citizenship)
      # Since there is no spinner, waiting for the modal to disappear
      click(BTN_SAVE_CITIZENSHIP)
      is_not_displayed?(CITIZENSHIP_MODAL)
    end
  end
  include Citizenship

  module SSN
    CURRENT_SSN = { css: '.personal-data .common-display-profile:nth-child(5) .profile-value' }.freeze
    EDIT_SSN = { css: '#edit-ssn-btn' }.freeze
    SSN_MODAL = { css: '#edit-ssn-modal.dialog.open.normal' }.freeze
    INPUT_SSN = { css: 'input[name$="ssn"]' }.freeze
    BTN_SAVE_SSN = { css: '#edit-ssn-save-btn' }.freeze

    def current_ssn
      text(CURRENT_SSN)
    end

    def edit_ssn(ssn:)
      click(EDIT_SSN)
      is_displayed?(SSN_MODAL)
      # Filling in ssn
      click(INPUT_SSN)
      enter(ssn, INPUT_SSN)
      # Since there is no spinner, waiting for the modal to disappear
      click(BTN_SAVE_SSN)
      is_not_displayed?(SSN_MODAL)
    end
  end
  include SSN

  module Identify
    CURRENT_IDENTITY = { css: '.personal-data .common-display-profile:nth-child(6) .col-sm-4 > p:nth-child(2)' }.freeze
    EDIT_IDENTIFY = { css: '#edit-identity-btn' }.freeze
    IDENTITY_MODAL = { css: '#edit-identity-modal .dialog-paper' }.freeze
    EXPAND_GENDER_CHOICES = { css: '#identity-gender-select + div' }.freeze
    LIST_GENDER_CHOICES = { css: 'div[id^="choices-identity-gender"]' }.freeze
    EXPAND_RACE_CHOICES = { css: '#identity-race-select + div' }.freeze
    LIST_RACE_CHOICES = { css: 'div[id^="choices-identity-race"]' }.freeze
    EXPAND_ETHNICITY_CHOICES = { css: '#identity-ethnicity-select + div' }.freeze
    LIST_ETHNICITY_CHOICES = { css: 'div[id^="choices-identity-ethnicity"]' }.freeze
    BTN_SAVE_IDENTIFY = { css: '#edit-identity-save-btn' }.freeze
    GENDER_F = 'Female'
    GENDER_M = 'Male'
    GENDER_U = 'Undisclosed'
    GENDER_O = 'Other'
    GENDER_NB = 'Non Binary'

    RACE_AI_AN = 'American Indian or Alaska Native'
    RACE_A = 'Asian'
    RACE_B_AA = 'Black/African American'
    RACE_NH_PI = 'Native Hawaiian Or Pacific Islander'
    RACE_O = 'Other Race'
    RACE_U = 'Undisclosed'
    RACE_W = 'White'

    ETHNICITY_H_L = 'Hispanic Or Latino'
    ETHNICITY_NH_NL = 'Not Hispanic Or Latino'
    ETHINICITY_U = 'Undisclosed'

    def current_identity
      # Returns a string of all values ex: "Undisclosed Undisclosed Undisclosed"
      find_elements(CURRENT_IDENTITY).map(&:text).join(' ')
    end

    def edit_identify_as(gender: GENDER_U, race: RACE_U, ethnicity: ETHINICITY_U)
      click(EDIT_IDENTIFY)
      is_displayed?(IDENTITY_MODAL)
      # Select Gender
      click(EXPAND_GENDER_CHOICES)
      click_element_from_list_by_text(LIST_GENDER_CHOICES, gender)
      # Select Race
      click(EXPAND_RACE_CHOICES)
      click_element_from_list_by_text(LIST_RACE_CHOICES, race)
      # Select Ethnicity
      click(EXPAND_ETHNICITY_CHOICES)
      click_element_from_list_by_text(LIST_ETHNICITY_CHOICES, ethnicity)
      # Since there is no spinner, waiting for the modal to disappear
      click(BTN_SAVE_IDENTIFY)
      is_not_displayed?(IDENTITY_MODAL)
    end
  end
  include Identify

  module HouseHold
    CURRENT_HOUSEHOLD_COUNT = { css: '.household-count-display > p:nth-child(2)' }.freeze
    EDIT_HOUSEHOLD = { css: '#edit-household-count-btn' }.freeze
    HOUSEHOLD_MODAL = { css: '#edit-household-count-modal.dialog.open.normal' }.freeze
    INPUT_COUNT = { css: 'input[name="household_count.total"]' }.freeze
    INPUT_ADULTS = { css: 'input[name="household_count.adults"]' }.freeze
    INPUT_CHILDREN = { css: 'input[name="household_count.children"]' }.freeze
    BTN_SAVE_HOUSEHOLD = { css: '#form-footer-submit-btn' }.freeze

    CURRENT_MARITAL_STATUS = { css: '.household-information .common-display-profile:nth-child(3) .profile-value' }.freeze
    EDIT_MARITAL_STATUS = { css: '#edit-marital-btn' }.freeze
    MARITAL_STATUS_MODAL = { css: '#edit-marital-modal.dialog.open.normal' }.freeze
    EXPAND_MARITAL_CHOICES = { css: '#contact-maritial-status + div' }.freeze
    LIST_MARTIAL_CHOICES = { css: 'div[id^="choices-contact-maritial-status"]' }.freeze
    BTN_SAVE_MARITAL_STATUS = { css: '#edit-marital-save-btn' }.freeze

    CURRENT_INCOME = { css: '.dollar-amount' }.freeze
    EDIT_INCOME = { css: '#edit-household-monthly-income' }.freeze
    INCOME_MODAL = { css: '#edit-household-monthly-income-modal.dialog.open.large' }.freeze
    INPUT_INCOME = { css: '#household-monthly-income-input-field' }.freeze
    BTN_SAVE_INCOME = { css: '#edit-monthly-income-save-btn' }.freeze

    MARITAL_STATUS_D = 'Divorced'
    MARITAL_STATUS_M_CU = 'Married/Civil Union'
    MARITAL_STATUS_S = 'Separated'
    MARITAL_STATUS_U = 'Undisclosed'

    def current_household_count
      # Returns either adult and child count ex: "2 1", or total count ex: "3"
      find_elements(CURRENT_HOUSEHOLD_COUNT).map(&:text).join(' ')
    end

    def edit_household_numerical_size(total: '1', adults: '', children: '')
      click(EDIT_HOUSEHOLD)
      is_displayed?(HOUSEHOLD_MODAL)
      # Fill Out totals
      clear_then_enter(total, INPUT_COUNT)
      clear_then_enter(adults, INPUT_ADULTS)
      clear_then_enter(children, INPUT_CHILDREN)
      # Since there is no spinner, waiting for the modal to disappear
      click(BTN_SAVE_HOUSEHOLD)
      is_not_displayed?(HOUSEHOLD_MODAL)
    end

    def current_marital_status
      text(CURRENT_MARITAL_STATUS)
    end

    def edit_marital_status(status: MARITAL_STATUS_U)
      click(EDIT_MARITAL_STATUS)
      is_displayed?(MARITAL_STATUS_MODAL)
      # Select marital status
      click(EXPAND_MARITAL_CHOICES)
      click_element_from_list_by_text(LIST_MARTIAL_CHOICES, status)
      # Since there is no spinner, waiting for the modal to disappear
      click(BTN_SAVE_MARITAL_STATUS)
      is_not_displayed?(MARITAL_STATUS_MODAL)
    end

    def current_income
      text(CURRENT_INCOME).tr('$,', '')
    end

    def edit_income(income:)
      click(EDIT_INCOME)
      is_displayed?(INCOME_MODAL)
      # Fill out income
      clear_then_enter(income, INPUT_INCOME)
      # Since there is no spinner, waiting for the modal to disappear
      click(BTN_SAVE_INCOME)
      is_not_displayed?(INCOME_MODAL)
    end
  end
  include HouseHold

  module Insurance
    INSURANCE_SECTION = { css: '.profile-panel.insurance-information'}.freeze
    INSURANCE_LIST = { css: '.payments-insurance-information'}.freeze
    CURRENT_PLAN = { css: '.payments-insurance-information__plan-info'}.freeze
    CURRENT_MEMBER_ID = { xpath: ".//div[div[@class='row']//text()[contains(., 'Member Id')]]//p" }.freeze
    CURRENT_GROUP_ID = { xpath: ".//div[div[@class='row']//text()[contains(., 'Group Id')]]//p" }.freeze
    CURRENT_COVERAGE_START = { xpath: ".//div[div[@class='row']//text()[contains(., 'Coverage Start')]]//p" }.freeze
    CURRENT_COVERAGE_END = { xpath: ".//div[div[@class='row']//text()[contains(., 'Coverage End')]]//p" }.freeze
    # edit modal
    INSURANCE_MODAL = { css: '#add-insurance-modal.dialog.open.normal' }.freeze
    INSURANCE_PLAN_DROPDOWN_OPEN = { css: '.payments-insurance-fields__plan .choices.is-open' }.freeze
    EXPAND_PLAN_TYPE = { css: '#insurance-plan-type + .choices__list' }.freeze
    LIST_PLAN_TYPE_CHOICES = { css: 'div[id^="choices-insurance-plan-type"]' }.freeze
    EXPAND_INSURANCE_PLAN = { css: '#insurance-plan + .choices__list' }.freeze
    LIST_INSURANCE_PLAN_CHOICES = { css: 'div[id^="choices-insurance-plan-item"]' }.freeze
    INPUT_MEMBER_ID = { css: '#insurance-member-id' }.freeze
    INPUT_GROUP_ID = { css: '#insurance-group-id' }.freeze
    INPUT_COVERAGE_START = {css: '#insurance-coverage-start' }.freeze
    INPUT_COVERAGE_END = { css: '#insurance-coverage-end' }.freeze
    # buttons
    ADD_INSURANCE_ICON = { css: '#add-insurance-button' }.freeze
    # TODO UU3-50414 edit button add an aria-label
    EDIT_INSURANCE_ICON = { css: '#edit-modal' }.freeze
    DELETE_INSURANCE_ICON = { css: 'div[aria-label="delete"]' }.freeze
    BTN_SAVE_INSURANCE = { css: '#edit-insurance-save-btn-' }.freeze

    COMMERCIAL_PLAN = 'Commercial'
    MEDICAID_PLAN = 'Medicaid'
    MEDICARE_PLAN = 'Medicare'
    UNKNOWN_PLAN = 'Unknown'

    def is_insurance_displayed?
      is_present?(INSURANCE_SECTION)
    end

    def list_insurances
      find_elements(INSURANCE_LIST).map(&:text).join(' ')
    end

    def add_insurance(plan_type: MEDICARE_PLAN, insurance_plan: MEDICARE_PLAN, member_id: '1EG4TE5MK72', group_id:'', coverage_start:'', coverage_end:'')
      click(ADD_INSURANCE_ICON)
      is_displayed?(INSURANCE_MODAL)
      # Fill out insurance information
      click(EXPAND_PLAN_TYPE)
      click_element_from_list_by_text(LIST_PLAN_TYPE_CHOICES, plan_type)
      click(EXPAND_INSURANCE_PLAN)
      is_displayed?(INSURANCE_PLAN_DROPDOWN_OPEN)
      click_element_from_list_by_text(LIST_INSURANCE_PLAN_CHOICES, insurance_plan)
      enter(member_id, INPUT_MEMBER_ID)
      enter(group_id, INPUT_GROUP_ID)
      enter(coverage_start, INPUT_COVERAGE_START)
      enter(coverage_end, INPUT_COVERAGE_END)
      # Since there is no spinner, waiting for the modal to disappear
      click(BTN_SAVE_INSURANCE)
      is_not_displayed?(INSURANCE_MODAL)
    end
  end
  include Insurance

  module Military
    MILITARY_SECTION = { css: '.profile-panel.military-information' }.freeze
    CURRENT_MILITARY_INFO = { css: '.military-information-display .display-line-value' }.freeze
    LINK_ADD_MILITARY_INFO = { css: '.military-information-add-info' }.freeze
    EDIT_MILITARY_INFO = { css: '#edit-military-btn' }.freeze
    MILITARY_MODAL = { css: '#military-info-modal.dialog.open.normal' }.freeze
    EXPAND_MILITARY_CHOICES = { css: '#affiliation + div' }.freeze
    LIST_MILITARY_CHOICES = { css: 'div[id^="choices-affiliation"]' }.freeze
    BTN_SAVE_MILITARY = { css: '#edit-military-save-btn' }.freeze

    AFFILIATION_CAREGIVER = 'Caregiver'
    AFFILIATION_FAMILY = 'Family Member'
    AFFILIATION_VETERAN = 'Military Member or Veteran'
    AFFILIATION_SPOUSE = 'Military Spouse'
    AFFILIATION_UNDISCLOSED = 'Prefer Not to Disclose'
    AFFILIATION_WIDOW = 'Widow/er'

    def is_military_displayed?
      is_present?(MILITARY_SECTION)
    end

    def current_military_info
      text(CURRENT_MILITARY_INFO)
    end

    def edit_military_affiliation(affiliation: AFFILIATION_CAREGIVER)
      click(LINK_ADD_MILITARY_INFO)
      is_displayed?(MILITARY_MODAL)
      # Select affiliation
      click(EXPAND_MILITARY_CHOICES)
      click_element_from_list_by_text(LIST_MILITARY_CHOICES, affiliation)
      # Since there is no spinner, waiting for the modal to disappear
      click(BTN_SAVE_MILITARY)
      is_not_displayed?(MILITARY_MODAL)
    end
  end
  include Military
end
