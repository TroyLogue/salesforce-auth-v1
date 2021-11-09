# frozen_string_literal: true

require_relative '../../root/pages/notifications'

module OrgSettings
  class EditOrgInfo < BasePage

    CANCEL_BUTTON = { css: 'button[aria-label="Cancel"]' }
    EDIT_ORG_INFO_HEADING = { css: '[data-test-element=heading]'}

    INPUT_NAME = { css: '[data-test-element=name]' }
    INPUT_DESCRIPTION = { css: '[data-test-element=description]' }
    INPUT_WEBSITE = { css: '[data-test-element=website]' }


    INPUTS_PHONE_NUMBER = { css: '[data-test-element^=phone_number_]' }
    INPUTS_PHONE_TYPE = { css: '[data-test-element^=phone_type_]' }
    REMOVE_BUTTONS_PHONE = { css: '[data-test-element^=phone_trash_' }

    INPUT_PHONE_NUMBER_FIRST = { css: '[data-test-element=phone_number_0]' }
    INPUT_PHONE_TYPE_FIRST = { css: '[data-test-element=phone_type_0]' }
    REMOVE_BUTTON_PHONE_FIRST = { css: '[data-test-element=phone_trash_0' }

    INPUTS_EMAIL = { css: '[data-test-element^=email_]' }
    REMOVE_BUTTONS_EMAIL = { css: '[data-test-element^=email_trash_' }

    INPUT_EMAIL_FIRST = { css: '[data-test-element=email_0]' }
    REMOVE_BUTTON_EMAIL_FIRST = { css: '[data-test-element=email_trash_0' }

    INPUTS_HOURS_DAY = { css: '[data-test-element^=hours_day_]' }
    INPUTS_HOURS_OPEN = { css: '[data-test-element^=hours_opens_]' }
    INPUTS_HOURS_CLOSE = { css: '[data-test-element^=hours_closes_]' }
    REMOVE_BUTTONS_HOURS = { css: '[data-test-element^=hours_trash_]' }

    INPUT_HOURS_DAY_FIRST = { css: '[data-test-element=hours_day_0]' }
    INPUT_HOURS_OPEN_FIRST = { css: '[data-test-element=hours_opens_0]' }
    INPUT_HOURS_CLOSE_FIRST = { css: '[data-test-element=hours_closes_0]' }
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
      save_field(input_field: INPUT_PHONE_NUMBER_FIRST, text_value: phone)
    end

    def get_phone
      text(INPUT_PHONE_NUMBER_FIRST)
    end
    def save_email(email)
      save_field(input_field: INPUTS_EMAIL_FIRST, text_value: email)
    end

    def get_email
      text(TEXT_EMAIL)
    end

    def get_time
      text(TEXT_HOURS_MONDAY)
    end


    private
    def save_field(input_field:, text_value:)
      delete_all_char(input_field)
      enter(text_value, input_field)
      click(SAVE_BUTTON)
    end

    #   def save_phone(phone)
    #     click(EDIT_PHONE)
    #     select_phone_type_fax
    #     save_field(save_button: SAVE_PHONE, input_field: INPUT_PHONE, text_value: phone)
    #   end
    #
    #
    #
    #   def save_email(email)
    #     edit_and_save_field(edit_button: EDIT_EMAIL, save_button: SAVE_EMAIL, input_field: INPUT_EMAIL, text_value: email)
    #   end
    #
    #
    #
    #   def save_address(address)
    #     edit_and_save_field(edit_button: EDIT_ADDRESS, save_button: SAVE_ADDRESS, input_field: INPUT_ADDRESS,
    #                         text_value: address)
    #   end
    #
    #
    #
    #   def save_website(website)
    #     edit_and_save_field(edit_button: EDIT_WEBSITE, save_button: SAVE_WEBSITE, input_field: INPUT_WEBSITE,
    #                         text_value: website)
    #   end
    #
    #
    #
    #   def save_time(time)
    #     click(EDIT_HOURS)
    #     sleep_for(1) # glide in animation
    #     is_displayed?(DIALOG_MODAL)
    #     click(INPUT_HOURS_FIRST)
    #     click_element_from_list_by_text(LIST_HOURS, time)
    #     click(SAVE_HOURS)
    #     is_field_saved?
    #   end
    #
    #
    #
    #   private
    #
    #   def edit_and_save_field(edit_button:, save_button:, input_field:, text_value:)
    #     click(edit_button)
    #     is_displayed?(DIALOG_MODAL)
    #
    #     save_field(save_button: save_button, input_field: input_field, text_value: text_value)
    #   end
    #
    #   def is_field_saved?
    #     wait_for_spinner
    #     is_not_displayed?(DIALOG_MODAL, 3)
    #     is_displayed?(Notifications::SUCCESS_BANNER)
    #   end
    #
    #   def save_field(save_button:, input_field:, text_value:)
    #     delete_all_char(input_field)
    #     enter(text_value, input_field)
    #     click(save_button)
    #     is_field_saved?
    #   end
    #
    #   def select_phone_type_fax
    #     click(PHONE_TYPE_SELECT_LIST)
    #     click_element_from_list_by_text(PHONE_TYPE_CHOICES, PHONE_TYPE_FAX)
    #   end
  end
end
