# frozen_string_literal: true

module OrgSettings
  class About < BasePage
    #ORG ABOUT
    EDIT_ORGANIZATION_INFO = { css: '[data-test-element=edit_org_link]' }
    TEXT_ORG_DESCRIPTION = { css: '[data-test-element=org_description]' }
    TEXT_ORG_WEBSITE = { css: '[data-test-element=org_website]' }
    TEXT_ORG_PHONES = { css: '.ui-contact-information__phone' }
    TEXT_ORG_EMAILS = { css: "[data-test-element^=org_email_address_]" }
    #TODO we have a https://uniteus.atlassian.net/browse/CP-542 task to add data-test-element attribute to each day of the week and its hour entries in progress
    TEXT_ORG_HOURS_TODAY = { css: '.org-info .ui-hours-of-operation-today' }
    TEXT_ORG_HOURS_MONDAY = { css: '[id^=monday-hours]' }.freeze

    #ORG LOCATIONS
    ORG_LOCATIONS_SECTION = { css: '[data-test-element=org_locations_section]' }
    ADD_LOCATION_LINK = { css: '[data-test-element=add_location_link]' }
    EDIT_LOCATION_LINK =  { css: '[data-test-element=edit_location_link]' }

    TEXT_FIRST_LOCATION_NAME = { css: '.ui-location__content' }
    TEXT_FIRST_LOCATION_ADDRESS = { css: '.ui-locations-address-link' }
    TEXT_FIRST_LOCATION_PHONE = { css: '.ui-location__phone' }
    TEXT_FIRST_LOCATION_EMAIL = { css: '.ui-location__email' }

    TEXT_FIRST_LOCATION_HOURS_TODAY = { css: '.ui-location__hours .ui-hours-of-operation-today' }
    TEXT_FIRST_LOCATION_HOURS_MONDAY = { css: '[id^=monday-hours]' }.freeze

    #PROGRAMS
    ORG_PROGRAMS_SECTION = {css: '[data-test-element=org_programs_section]'}
    ADD_PROGRAM_LINK = { css: '[data-test-element=add_program_link]' }

    def page_displayed?
      is_displayed?(TEXT_ORG_DESCRIPTION) &&
      is_displayed?(ORG_LOCATIONS_SECTION) &&
      is_displayed?(ORG_PROGRAMS_SECTION)
    end

    def edit_org_info
      click(EDIT_ORGANIZATION_INFO)
    end

    def get_description
      text(TEXT_ORG_DESCRIPTION)
    end

    def get_website
      text(TEXT_ORG_WEBSITE)
    end

    def get_phones
      text(TEXT_ORG_PHONES)
    end

    def get_emails
      text(TEXT_ORG_EMAILS)
    end

    def get_time
      click(TEXT_ORG_HOURS_TODAY)
      text(TEXT_ORG_HOURS_MONDAY)
    end

    def edit_first_location
      page_displayed?
      click(EDIT_LOCATION_LINK)
    end

    def get_first_location_address
      text(TEXT_FIRST_LOCATION_ADDRESS)
    end

    def get_first_location_phone
      text(TEXT_FIRST_LOCATION_PHONE)
    end

    def get_first_location_name
      text(TEXT_FIRST_LOCATION_NAME)
    end

    def get_first_location_email
      text(TEXT_FIRST_LOCATION_EMAIL)
    end

    def get_first_location_time
      click(TEXT_FIRST_LOCATION_HOURS_TODAY)
      text(TEXT_FIRST_LOCATION_HOURS_MONDAY)
    end
  end
end
