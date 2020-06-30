require_relative '../../../shared_components/base_page'
require_relative '../../../spec_helper'

class WidgetPage < BasePage
    FIRST_NAME = { css: '#uu_contact_first_name' }
    LAST_NAME = { css: '#uu_contact_last_name' }
    MIDDLE_NAME_INITIAL = { css: '#uu_contact_middle_name' }
    DOB = { css: '#uu_contact_date_of_birth' }
    PHONE = { css: '#uu_contact_phone_number' }
    EMAIL = { css: '#uu_contact_email_address' }
    ADDRESS_FIELD = { css: '.address-field > .row:nth-of-type(2) > div > .form-group:nth-of-type(1) > .field-container > .control-container > .form-control.is-searchable > div' } 
    ADDRESS_TYPE = { css: '#react-select-2--option-1' }
    ADDRESS_LINE_1 = { css: '#uu_contact_address-line1' }
    ADDRESS_LINE_2 = { css: '#uu_contact_address-line2' }
    CITY = { css: '#uu_contact_address-city' }
    STATE_FIELD = { css: '.address-field > .row:nth-of-type(3) > div:nth-of-type(1) > .form-group > .field-container > .control-container > .form-control.is-searchable > div' }
    STATE = { css: '#react-select-3--option-5' }
    ZIP = { css: '#uu_contact_address-postal-code' }
    GENDER_FIELD = { css: '#react-select-4--value' }
    GENDER = { css: '#react-select-4--option-1' }
    RACE_FIELD = { css: '#react-select-5--value' }
    RACE = { css: '#react-select-5--option-2' }
    ETHNICITY_FIELD = { css: '#react-select-6--value' }
    ETHNICITY = { css: '#react-select-6--option-0' }
    SSN = { css: '#uu_contact_ssn' }
    GROSS_MONTHLY_INCOME = { css: '#uu_contact_gross_monthly_income' }
    MILITARY_AFFILIATION_FIELD = { css: '#react-select-7--value' }
    MILITARY_AFFILIATION = { css: '#react-select-7--option-1' }
    SCHOOL = { css: '#undefined-s0-q0' }
    SCHOOL_LOCATION = { css: '#undefined-s1-q0' }
    SERVICES_FIELD = { css: '#react-select-14--value'}
    SERVICES = { css: '#react-select-14--option-2' }
    DESCRIPTION = { css: '#uu_description' }
    SIG_PAD = { css: '.m-signature-pad--body > canvas' }
    SUBMIT = { css: '.button-submit'}

    CONTAINER = { css: '#container' }
    HEADER = { css: 'h3' }
    LINK = { css: 'a'}

    PATH = '/assistance-request/7lCV515cZEd1oT8SJALFk2r_5YBjRxyRMdASLCju/'
    
    def get_widget_page
        driver.get ENV['widget_url'] + PATH
    end

    def fill_in_form
        enter('John', FIRST_NAME)
        enter('Doe', LAST_NAME)
        enter('J', MIDDLE_NAME_INITIAL)
        enter('01/01/1990', DOB)
        click(PHONE)
        enter('9999999999', PHONE)
        enter('JJ@example.com', EMAIL)
        click(ADDRESS_FIELD)
        click(ADDRESS_TYPE)
        enter('10 Main Street', ADDRESS_LINE_1)
        enter('Apartment 5', ADDRESS_LINE_2)
        enter('San Francisco', CITY)
        click(STATE_FIELD)
        click(STATE)
        enter('90210', ZIP)
        click(GENDER_FIELD)
        click(GENDER)
        click(RACE_FIELD)
        click(RACE)
        click(ETHNICITY_FIELD)
        click(ETHNICITY)
        enter('999999999', SSN)
        enter('9876', GROSS_MONTHLY_INCOME)
        click(MILITARY_AFFILIATION_FIELD)
        click(MILITARY_AFFILIATION)
        enter('USC', SCHOOL)
        enter('California', SCHOOL_LOCATION)
        click(SERVICES_FIELD)
        click(SERVICES)
        enter('This is a test', DESCRIPTION)
        click(SIG_PAD)
        click(SUBMIT)
        success_page_displayed?
    end

    def success_page_displayed?
        is_displayed?(CONTAINER) && is_displayed?(HEADER)
    end

    def success_message
        find_within(CONTAINER, HEADER).text
    end

    def success_link
        find_within(CONTAINER, LINK).text
    end

    def success_pdf
        find_within(CONTAINER, LINK).attribute('href')
    end
end