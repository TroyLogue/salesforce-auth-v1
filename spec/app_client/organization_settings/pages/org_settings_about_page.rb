# frozen_string_literal: true

module OrgSettings
  class About < BasePage
    #ORG ABOUT
    EDIT_ORGANIZATION_INFO = { css: '[data-test-element=edit_org_link]' }
    TEXT_DESCRIPTION = { css: '[data-test-element=org_description]' }
    TEXT_WEBSITE = { css: '[data-test-element=org_website]' }
    TEXT_PHONES = { css: '.ui-contact-information__phone' }
    TEXT_EMAILS = { css: "[data-test-element^=org_email_address_]" }
    #TODO we have a https://uniteus.atlassian.net/browse/CP-542 task to add data-test-element attribute to each day of the week and its hour entries in progress
    TEXT_HOURS_TODAY = { xpath: '//*[@data-test-element="org_hours"]//div[@class="ui-hours-of-operation-today"]'}
    TEXT_HOURS_MONDAY = { xpath: "//div[contains(@id,'monday')]/parent::div/following-sibling::div"}.freeze

    #ORG LOCATIONS
    ORG_LOCATIONS_SECTION = { css: '[data-test-element=org_locations_section]' }
    ADD_LOCATION_LINK = { css: '[data-test-element=add_location_link]' }

    #PROGRAMS
    ORG_PROGRAMS_SECTION = {css: '[data-test-element=org_programs_section]'}
    ADD_PROGRAM_LINK = { css: '[data-test-element=add_program_link]' }

    def page_displayed?
      is_displayed?(TEXT_DESCRIPTION) &&
      is_displayed?(ORG_LOCATIONS_SECTION) &&
      is_displayed?(ORG_PROGRAMS_SECTION)
    end

    def edit_org_info
      click(EDIT_ORGANIZATION_INFO)
    end

    def get_description
      text(TEXT_DESCRIPTION)
    end

    def get_website
      text(TEXT_WEBSITE)
    end

    def get_phones
      text(TEXT_PHONES)
    end

    def get_emails
      text(TEXT_EMAILS)
    end

    def get_time
      click(TEXT_HOURS_TODAY)
      text(TEXT_HOURS_MONDAY)
    end
  end
end
