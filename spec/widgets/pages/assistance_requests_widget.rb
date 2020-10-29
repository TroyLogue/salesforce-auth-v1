# frozen-string-literal: true

require_relative '../../shared_components/base_page'

class AssistanceRequestWidget < BasePage
  WIDGET_FORM = { css: 'form' }.freeze
  CONTAINER = { css: '#container' }.freeze
  HEADER = { css: 'h3' }.freeze
  LINK = { css: 'a' }.freeze
  SUBMITTING_TEXT = { css: '#container > div > div > div:nth-child(7)' }.freeze

  # Default fields
  FIRST_NAME_INPUT = { css: '#uu_contact_first_name' }.freeze
  LAST_NAME_INPUT = { css: '#uu_contact_last_name' }.freeze
  DOB_INPUT = { css: '#uu_contact_date_of_birth' }.freeze
  SERVICES_DROPDOWN = { css: 'label[for="uu_service_types"] + div' }.freeze
  SERVICES_INPUT = { css: '#uu_service_types' }.freeze
  DESCRIPTION_TEXTAREA = { css: '#uu_description' }.freeze

  # Consent
  SIG_PAD = { css: '.m-signature-pad--body > canvas' }.freeze

  # Configured Fields
  # Contact Information
  MIDDLE_NAME_INITIAL_INPUT = { css: '#uu_contact_middle_name' }.freeze
  PHONE_INPUT = { css: '#uu_contact_phone_number' }.freeze
  EMAIL_INPUT = { css: '#uu_contact_email_address' }.freeze
  ADDRESS_TYPE_DROPDOWN = { css: '.address-field-type > div' }.freeze
  ADDRESS_TYPE_FIRST_OPTION = { css: '#react-select-2--option-1' }.freeze
  ADDRESS_LINE_1_INPUT = { css: '#uu_contact_address-line1' }.freeze
  ADDRESS_LINE_2_INPUT = { css: '#uu_contact_address-line2' }.freeze
  CITY_INPUT = { css: '#uu_contact_address-city' }.freeze
  STATE_DROPDOWN = { css: '.address-field-state > div' }.freeze
  STATE_FIFTH_OPTION = { css: '#react-select-3--option-5' }.freeze
  ZIP_INPUT = { css: '#uu_contact_address-postal-code' }.freeze

  # Personal Information
  CITIZENSHIP_DROPDOWN = { css: '#react-select-4--value' }.freeze
  CITIZENSHIP_OPTION = { css: '#react-select-4--option-1' }.freeze
  GENDER_DROPDOWN = { css: '#react-select-5--value' }.freeze
  GENDER_FIRST_OPTION = { css: '#react-select-5--option-1' }.freeze
  RACE_DROPDOWN = { css: '#react-select-6--value' }.freeze
  RACE_SECOND_OPTION = { css: '#react-select-6--option-2' }.freeze
  ETHNICITY_DROPDOWN = { css: '#react-select-7--value' }.freeze
  ETHNICITY_FIRST_OPTION = { css: '#react-select-7--option-0' }.freeze
  SSN_INPUT = { css: '#uu_contact_ssn' }.freeze
  GROSS_MONTHLY_INCOME_INPUT = { css: '#uu_contact_gross_monthly_income' }.freeze

  # Military Inforomation
  MILITARY_AFFILIATION_DROPDOWN = { css: '#react-select-8--value' }.freeze
  MILITARY_AFFILIATION_FIRST_OPTION = { css: '#react-select-8--option-1' }.freeze

  # Custom Form fields
  SCHOOL_INPUT = { css: '#undefined-s0-q0' }.freeze
  SCHOOL_LOCATION_INPUT = { css: '#undefined-s1-q0' }.freeze

  SUBMIT_BUTTON = { css: '.button-submit' }.freeze

  SUCCESS_MESSAGE = 'Success !'
  DOWNLOAD_MESSAGE = 'Download Your Signed Consent Form'
  PDF_TEXT = 'pdf'

  def get_widget_page
    driver.get ENV['widgets_url']
  end

  def get_default_widget_page
    driver.get ENV['widgets_default_url']
  end

  def fill_default_form_fields(first_name:, last_name:, dob:, description:)
    enter(first_name, FIRST_NAME_INPUT)
    enter(last_name, LAST_NAME_INPUT)
    enter(dob, DOB_INPUT)

    # Select second service needed
    click(SERVICES_DROPDOWN)
    enter_and_return('Benefits', SERVICES_INPUT)
    enter(description, DESCRIPTION_TEXTAREA)

    # sign consent form
    click(SIG_PAD)
  end

  def fill_configured_form_fields(middle_initial:, phone:, email:, ssn:, address_1:, address_2:, city:, zip:, income:)
    # Contact Information
    enter(middle_initial, MIDDLE_NAME_INITIAL_INPUT)
    click(PHONE_INPUT)
    enter(phone, PHONE_INPUT)
    enter(email, EMAIL_INPUT)
    click(ADDRESS_TYPE_DROPDOWN)
    click(ADDRESS_TYPE_FIRST_OPTION)
    enter(address_1, ADDRESS_LINE_1_INPUT)
    enter(address_2, ADDRESS_LINE_2_INPUT)
    enter(city, CITY_INPUT)
    click(STATE_DROPDOWN)
    click(STATE_FIFTH_OPTION)
    enter(zip, ZIP_INPUT)

    # Personal Infomration
    click(CITIZENSHIP_DROPDOWN)
    click(CITIZENSHIP_OPTION)
    click(GENDER_DROPDOWN)
    click(GENDER_FIRST_OPTION)
    click(RACE_DROPDOWN)
    click(RACE_SECOND_OPTION)
    click(ETHNICITY_DROPDOWN)
    click(ETHNICITY_FIRST_OPTION)
    enter(ssn, SSN_INPUT)
    enter(income, GROSS_MONTHLY_INCOME_INPUT)

    # Military Information
    click(MILITARY_AFFILIATION_DROPDOWN)
    click(MILITARY_AFFILIATION_FIRST_OPTION)
  end

  def fill_custom_form_fields(**params)
    # Current Custom Form: Ivy League Intake Form
    enter(params[:school_name], SCHOOL_INPUT)
    enter(params[:school_location], SCHOOL_LOCATION_INPUT)
  end

  def submit_form
    click(SUBMIT_BUTTON)
    is_displayed?(SUBMITTING_TEXT)
  end

  def widget_page_displayed?
    is_displayed?(WIDGET_FORM)
  end

  def success_page_displayed?
    is_not_displayed?(SUBMITTING_TEXT)
    find_element_with_text(HEADER, SUCCESS_MESSAGE)
  end

  def success_message
    find_within(CONTAINER, HEADER).text
  end

  def success_link_message
    find_within(CONTAINER, LINK).text
  end

  def success_pdf
    find_within(CONTAINER, LINK).attribute('href')
  end
end
