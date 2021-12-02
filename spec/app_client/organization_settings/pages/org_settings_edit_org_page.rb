# frozen_string_literal: true

require_relative '../../root/pages/notifications'

module OrgSettings
  class EditOrgInfo < BasePage

    CANCEL_BUTTON = { css: 'button[aria-label="Cancel"]' }
    EDIT_ORG_INFO_HEADING = { css: '[data-test-element=heading]'}

    INPUT_NAME = { css: 'input[id=org-name]' }
    INPUT_DESCRIPTION = { css: '.public-DraftEditor-content' }
    INPUT_WEBSITE = { css: 'input[id=org-website]' }

    INPUTS_PHONE_NUMBER = { css: '[data-test-element^=phone_number_]' }
    INPUTS_PHONE_TYPE = { css: '[data-test-element^=phone_type_]' }
    REMOVE_BUTTONS_PHONE = { css: '[data-test-element^=phone_trash_' }

    INPUT_PHONE_NUMBER_FIRST = { css: 'input[id=org-phone-0]' }
    INPUT_PHONE_TYPE_FIRST = { css: '[data-test-element=phone_type_0]' }
    REMOVE_BUTTON_PHONE_FIRST = { css: '[data-test-element=phone_trash_0' }

    PHONE_TYPE_SELECT_LIST = { css: '[id="org-phone-type-0"] + .choices__list' }.freeze
    PHONE_TYPE_CHOICES = { css: '[id^="choices-org-phone-type-0"]' }.freeze
    PHONE_TYPE_FAX = 'Fax'

    INPUTS_EMAIL = { css: '[data-test-element^=email_]' }
    REMOVE_BUTTONS_EMAIL = { css: '[data-test-element^=email_trash_' }

    INPUT_EMAIL_FIRST = { css: 'input[id=org-email-0]' }
    REMOVE_BUTTON_EMAIL_FIRST = { css: '[data-test-element=email_trash_0' }

    INPUT_HOURS_DAY_FIRST = { css: '[id="org-hours-day-0"]' }
    INPUT_HOURS_OPEN_FIRST = { css: '[id="org-hours-starts-0"]' }
    INPUT_HOURS_CLOSE_FIRST = { css: '[id="org-hours-ends-0"]' }
    LIST_HOURS = { css: '[id^="choices-org-hours-starts-0"]' }.freeze
    REMOVE_BUTTON_HOURS_FIRST = { css: '[data-test-element=hours_trash_0]' }

    ADD_PHONE_BUTTON = { css: '[data-test-element=add_phone]' }.freeze
    ADD_EMAIL_BUTTON = { css: '[data-test-element=add_email]' }.freeze
    ADD_HOURS_BUTTON = { css: '[data-test-element=add_hours]' }.freeze

    SAVE_BUTTON = { css: '[data-test-element=save]' }

    def page_displayed?
      is_displayed?(EDIT_ORG_INFO_HEADING) &&
        is_displayed?(CANCEL_BUTTON) &&
        is_displayed?(SAVE_BUTTON)
    end

    def save_description(description)
      save_field(input_field: INPUT_DESCRIPTION, text_value: description)
    end

    def get_description
      text(TEXT_DESCRIPTION)
    end

    def save_website(website)
      save_field(input_field: INPUT_WEBSITE, text_value: website)
    end

    def get_website
      text(TEXT_WEBSITE)
    end

    def save_phone(phone)
      select_phone_type_fax
      save_field(input_field: INPUT_PHONE_NUMBER_FIRST, text_value: phone)
    end

    def get_phone
      text(INPUT_PHONE_NUMBER_FIRST)
    end

    def save_email(email)
      save_field(input_field: INPUT_EMAIL_FIRST, text_value: email)
    end

    def get_email
      text(TEXT_EMAIL)
    end

    def get_time
      text(TEXT_HOURS_MONDAY)
    end

    def save_time(time)
      click_via_js(INPUT_HOURS_OPEN_FIRST)
      click_element_from_list_by_text(LIST_HOURS, time)
      click_via_js(SAVE_BUTTON)
    end

    private
    def save_field(input_field:, text_value:)
      delete_all_char(input_field)
      enter(text_value, input_field)
      click_via_js(SAVE_BUTTON)
    end

    def select_phone_type_fax
      click_via_js(PHONE_TYPE_SELECT_LIST)
      click_element_from_list_by_text(PHONE_TYPE_CHOICES, PHONE_TYPE_FAX)
    end
  end
end
