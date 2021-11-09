# frozen_string_literal: true

require_relative '../../root/pages/notifications'

module OrgSettings
  class About < BasePage
    #ORG ABOUT
    EDIT_ORGANIZATION_INFO = { css: '[data-test-element=edit_org_link]' }
    TEXT_DESCRIPTION = { css: '[data-test-element=org_description]' }
    TEXT_WEBSITE = { css: '[data-test-element=org_website]' }
    TEXT_PHONE = { css: '[data-test-element^=org_phone_]' }
    TEXT_EMAILS = { css: "[data-test-element^=org_email_address_]" }
    TEXT_HOURS_TODAY = { css: '[data-test-element=org_hours]'}

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

    # def get_time
    #   text(TEXT_HOURS_MONDAY)
    # end

    def get_locations
      text(TEXT_LOCATIONS)
    end

    def get_programs
      #TODO
    end
  end
end
