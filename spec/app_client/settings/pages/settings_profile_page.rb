require_relative '../../root/pages/notifications'

module Settings
  class OrganizationProfile < BasePage
    DIALOG_MODAL = { css: '.dialog.open' }

    EDIT_DESCRIPTION = { css: '#edit-description-btn' }
    INPUT_DESCRIPTION = { css: '.public-DraftStyleDefault-block > span' }
    SAVE_DESCRIPTION = { css: '#edit-description-save-btn' }
    TEXT_DESCRIPTION = { css: '.html-parsed-text' }

    EDIT_PHONE = { css: '#edit-phone-number-btn' }
    INPUT_PHONE = { css: 'input[id^="phoneNumber"]' }
    SAVE_PHONE = { css: '#edit-phone-number-save-btn' }
    TEXT_PHONE = { css: '.phone-number-display > p' }

    EDIT_EMAIL = { css: '#edit-email-btn' }
    INPUT_EMAIL = { css: 'input[name="emails[0].email_address"]' }
    SAVE_EMAIL = { css: '#edit-email-save-btn' }
    TEXT_EMAIL = { css: '.email > p' }

    EDIT_ADDRESS = { css: '#edit-address-btn' }
    INPUT_ADDRESS = { css: 'input[name="addresses[0].line_2"]' }
    SAVE_ADDRESS = { css: '#edit-address-save-btn' }
    TEXT_ADDRESS = { css: '.address__content' }

    EDIT_WEBSITE = { css: '#edit-website-btn' }
    INPUT_WEBSITE = { css: '#website-url' }
    SAVE_WEBSITE = { css: '#edit-url-modal-save-btn' }
    TEXT_WEBSITE = { css: '#website-url-link' }

    EDIT_HOURS = { css: '#edit-hours-btn' }
    INPUT_HOURS = { css: '.hours-of-operation-day-fields__opens-at .choices__item.choices__item--selectable' }
    LIST_HOURS = { css: 'div[id^="choices-group-hours-of-operation-fields-day-field-0-opens-at-item-choice"]' }
    SAVE_HOURS = { css: '#edit-hours-modal-save-btn' }
    TEXT_HOURS = { css: '.ui-hours-of-operation-day__hours' }

    def page_displayed?
      is_displayed?(EDIT_DESCRIPTION)
    end

    def save_description(description)
      save_field(edit_button: EDIT_DESCRIPTION, save_button: SAVE_DESCRIPTION, input_field: INPUT_DESCRIPTION, text_value: description)
      click_within(Notifications::SUCCESS_BANNER, Notifications::CLOSE_BANNER)
    end

    def get_description
      text(TEXT_DESCRIPTION)
    end

    def save_phone(phone)
      save_field(edit_button: EDIT_PHONE, save_button: SAVE_PHONE, input_field: INPUT_PHONE, text_value: phone)
      click_within(Notifications::SUCCESS_BANNER, Notifications::CLOSE_BANNER)
    end

    def get_phone
      text(TEXT_PHONE)
    end

    def save_email(email)
      save_field(edit_button: EDIT_EMAIL, save_button: SAVE_EMAIL, input_field: INPUT_EMAIL, text_value: email)
      click_within(Notifications::SUCCESS_BANNER, Notifications::CLOSE_BANNER)
    end

    def get_email
      text(TEXT_EMAIL)
    end

    def save_address(address)
      save_field(edit_button: EDIT_ADDRESS, save_button: SAVE_ADDRESS, input_field: INPUT_ADDRESS, text_value: address)
      click_within(Notifications::SUCCESS_BANNER, Notifications::CLOSE_BANNER)
    end

    def get_address
      text(TEXT_ADDRESS)
    end

    def save_website(website)
      save_field(edit_button: EDIT_WEBSITE, save_button: SAVE_WEBSITE, input_field: INPUT_WEBSITE, text_value: website)
      click_within(Notifications::SUCCESS_BANNER, Notifications::CLOSE_BANNER)
    end

    def get_website
      text(TEXT_WEBSITE)
    end

    def save_time(time)
      click(EDIT_HOURS)
      sleep_for(1) #glide in animation
      is_displayed?(DIALOG_MODAL)
      click(INPUT_HOURS)
      click_element_from_list_by_text(LIST_HOURS, time)
      click(SAVE_HOURS)
      is_field_saved?
      click_within(Notifications::SUCCESS_BANNER, Notifications::CLOSE_BANNER)
    end

    def get_time
      text(TEXT_HOURS)
    end

    private

    def save_field(edit_button:, save_button:, input_field:, text_value:)
      click(edit_button)
      sleep_for(1) #glide in animation
      is_displayed?(DIALOG_MODAL)

      #deleting everything before entering
      delete_all_char(input_field)
      enter(text_value, input_field)
      click(save_button)
      is_field_saved?
    end

    def is_field_saved?
      wait_for_spinner
      is_not_displayed?(DIALOG_MODAL, 3)
      is_displayed?(Notifications::SUCCESS_BANNER)
    end
  end
end
