# frozen_string_literal: true

module OrgSettings
  class EditOrgLocation < BasePage
    include ContactComponents

    CANCEL_BUTTON = { css: '[data-test-element=cancel]' }
    EDIT_LOCATION_HEADING = { css: '[data-test-element=heading]'}

    INPUT_LOCATION_NAME = { css: 'input[id=location-name]' }
    INPUT_LOCATION_ADDRESS = { css: 'input[id=location-address-address-field]' }
    INPUT_LOCATION_ADDRESS_OPTIONAL = { css: 'input[id=location-line2]' }

    SAVE_BUTTON = { css: '[data-test-element=save]' }
    DELETE_BUTTON = { css: '[data-test-element=delete]' }

    def page_displayed?
      is_displayed?(EDIT_LOCATION_HEADING) &&
      is_displayed?(CANCEL_BUTTON) &&
      is_displayed?(INPUT_LOCATION_NAME) &&
      is_displayed?(INPUT_LOCATION_ADDRESS) &&
      is_displayed?(SAVE_BUTTON)
    end

    ###
    def save_address(address)
      save_field(input_field: INPUT_LOCATION_ADDRESS, text_value: address)
    end

    def save_address_line_2(address_line_2)
      save_field(input_field: INPUT_LOCATION_ADDRESS_OPTIONAL, text_value: address_line_2)
    end

    def save_phone(phone)
      select_phone_type_fax
      save_field(input_field: INPUT_PHONE_NUMBER_FIRST, text_value: phone)
    end

    def save_email(email)
      save_field(input_field: INPUT_EMAIL_FIRST, text_value: email)
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
