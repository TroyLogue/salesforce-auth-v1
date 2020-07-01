require_relative '../../shared_components/base_page'
require_relative '../../spec_helper'

class AssistanceRequestWidget < BasePage
    WIDGET_FORM = { css: 'form' }
    FIRST_NAME_INPUT = { css: '#uu_contact_first_name' }
    LAST_NAME_INPUT = { css: '#uu_contact_last_name' }
    MIDDLE_NAME_INITIAL_INPUT = { css: '#uu_contact_middle_name' }
    DOB_INPUT = { css: '#uu_contact_date_of_birth' }
    PHONE_INPUT = { css: '#uu_contact_phone_number' }
    EMAIL_INPUT = { css: '#uu_contact_email_address' }
    ADDRESS_DROPDOWN = { css: '.address-field > .row:nth-of-type(2) > div > .form-group:nth-of-type(1) > .field-container > .control-container > .form-control.is-searchable > div' } 
    ADDRESS_TYPE_FIRST_OPTION = { css: '#react-select-2--option-1' }
    ADDRESS_LINE_1_INPUT = { css: '#uu_contact_address-line1' }
    ADDRESS_LINE_2_INPUT = { css: '#uu_contact_address-line2' }
    CITY_INPUT = { css: '#uu_contact_address-city' }
    STATE_DROPDOWN = { css: '.address-field > .row:nth-of-type(3) > div:nth-of-type(1) > .form-group > .field-container > .control-container > .form-control.is-searchable > div' }
    STATE_FIFTH_OPTION = { css: '#react-select-3--option-5' }
    ZIP_INPUT = { css: '#uu_contact_address-postal-code' }
    GENDER_DROPDOWN = { css: '#react-select-4--value' }
    GENDER_FIRST_OPTION = { css: '#react-select-4--option-1' }
    RACE_DROPDOWN = { css: '#react-select-5--value' }
    RACE_SECOND_OPTION = { css: '#react-select-5--option-2' }
    ETHNICITY_DROPDOWN = { css: '#react-select-6--value' }
    ETHNICITY_FIRST_OPTION = { css: '#react-select-6--option-0' }
    SSN_INPUT = { css: '#uu_contact_ssn' }
    GROSS_MONTHLY_INCOME_INPUT = { css: '#uu_contact_gross_monthly_income' }
    MILITARY_AFFILIATION_DROPDOWN = { css: '#react-select-7--value' }
    MILITARY_AFFILIATION_FIRST_OPTION = { css: '#react-select-7--option-1' }
    SCHOOL_INPUT = { css: '#undefined-s0-q0' }
    SCHOOL_LOCATION_INPUT = { css: '#undefined-s1-q0' }
    SERVICES_DROPDOWN = { css: '#react-select-14--value'}
    SERVICES_SECOND_OPTION = { css: '#react-select-14--option-2' }
    DESCRIPTION_TEXTAREA = { css: '#uu_description' }
    SIG_PAD = { css: '.m-signature-pad--body > canvas' }
    SUBMIT_BUTTON = { css: '.button-submit'}
    SUCCESS_MESSAGE = "Success !"
    DOWNLOAD_MESSAGE = "Download Your Signed Consent Form"
    PDF_TEXT = 'pdf'

    CONTAINER = { css: '#container' }
    HEADER = { css: 'h3' }
    LINK = { css: 'a'}

    def get_widget_page
        driver.get ENV['assistance_request_url']
    end

    def submit_form_with_all_fields(
        first_name: Faker::Name.first_name,
        last_name:,
        middle_initial:,
        dob:,
        email:,
        ssn:,
        description:,
        address_1:,
        address_2:,
        city:,
        zip:
    )
        enter(first_name, FIRST_NAME_INPUT)
        enter(last_name, LAST_NAME_INPUT)
        enter(middle_initial, MIDDLE_NAME_INITIAL_INPUT)
        enter(dob, DOB_INPUT)
        click(PHONE_INPUT)
        enter('9999999999', PHONE_INPUT)
        enter(email, EMAIL_INPUT)
        click(ADDRESS_DROPDOWN)
        click(ADDRESS_TYPE_FIRST_OPTION)
        enter(address_1, ADDRESS_LINE_1_INPUT)
        enter(address_2, ADDRESS_LINE_2_INPUT)
        enter(city, CITY_INPUT)
        click(STATE_DROPDOWN)
        click(STATE_FIFTH_OPTION)
        enter(zip, ZIP_INPUT)
        click(GENDER_DROPDOWN)
        click(GENDER_FIRST_OPTION)
        click(RACE_DROPDOWN)
        click(RACE_SECOND_OPTION)
        click(ETHNICITY_DROPDOWN)
        click(ETHNICITY_FIRST_OPTION)
        enter(ssn, SSN_INPUT)
        enter('9876', GROSS_MONTHLY_INCOME_INPUT)
        click(MILITARY_AFFILIATION_DROPDOWN)
        click(MILITARY_AFFILIATION_FIRST_OPTION)
        enter('USC', SCHOOL_INPUT)
        enter('California', SCHOOL_LOCATION_INPUT)
        click(SERVICES_DROPDOWN)
        click(SERVICES_SECOND_OPTION)
        enter(description, DESCRIPTION_TEXTAREA)
        click(SIG_PAD)
        click(SUBMIT_BUTTON)
    end

    def widget_page_displayed?
        is_displayed?(WIDGET_FORM)
    end

    def success_page_displayed?
        find_element_with_text({ css: 'h3' }, 'Success !')
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