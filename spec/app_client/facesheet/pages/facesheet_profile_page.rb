require_relative '../../../shared_components/base_page'

class Profile < BasePage

    FACESHEET_PROFILE = { css: '.facesheet-profile' }
    ERROR_MESSAGE = { css: '.dialog.open .ui-form-field__error'}
    BTN_CLOSE = { css: '.dialog.open .title.title-closeable > a '}

    EDIT_PHONE = { css: '#edit-phone-number-btn' }
    ADD_PHONE = { css: '#add-phone-link' }
    INPUT_PHONE = { css: 'input[id^="phoneNumber"]' }
    EXPAND_TYPE_CHOICES = { css: 'div[aria-activedescendant^="choices-phoneType"]' }
    LIST_TYPE_CHOICES = { css: 'div[id^="choices-phoneType"]'}
    PHONE_CHECKBOX_MESSAGE = { css: '.profile-phone-fields div > input[id$="message"] + label' }
    PHONE_CHECKBOX_NOTIFICATION = { css: '.profile-phone-fields div > input[id$="notification"] + label' }
    BTN_SAVE_PHONE = { css: '#edit-phone-number-save-btn' }
    BTN_REMOVE_PHONE = { css: '.remove-phone-button' }
    BTN_REMOVE_CONFIRM = { css: '.confirm-confirmation'}

    EDIT_EMAIL = { css: '#edit-email-btn' }
    ADD_EMAIL = { css: '#add-email-link' }
    INPUT_EMAIL = { css: 'input[name="emails[0].email_address"]'}
    EMAIL_CHECKBOX_MESSAGE = { css: '.inline-email-address div > input[id$="message"] + label' }
    EMAIL_CHECKBOX_NOTIFICATION = { css: '.inline-email-address  div > input[id$="notification"] + label' }
    BTN_SAVE_EMAIL = { css: '#edit-email-save-btn' }
    BTN_REMOVE_EMAIL = { css: '.remove-email-button'}

    EDIT_CONTACT_PREFERRENCES = { css: '#edit-contact-preferences-btn' }
    EXPAND_METHOD_CHOICES = { css: 'div[aria-activedescendant^="choices-preferred-method-of-contact-field-item-choice"]' }
    LIST_METHOD_CHOICES = { css: 'div[id^="choices-preferred-method-of-contact-field-item-choice"]'}
    EXPAND_TIME_CHOICES = { css: 'div[aria-activedescendant^="choices-best-time-to-contact-field-item-choice"]' }
    LIST_TIME_CHOICES = { css: 'div[id^="choices-best-time-to-contact-field-item-choice"]'}
    BTN_SAVE_PREFERRENCES = { css: '#edit-communication-preferences-save-btn' }


    def page_displayed?
        is_displayed?(FACESHEET_PROFILE)
    end

    def get_error_message
        text(ERROR_MESSAGE)
    end

    def add_phone_number(phone:, type:)
        click(EDIT_PHONE)
        sleep_for(1) # slide in animation!
        click(ADD_PHONE)
        click(INPUT_PHONE)
        enter(phone, INPUT_PHONE)
        click(EXPAND_TYPE_CHOICES)
        click_element_from_list_by_text(LIST_TYPE_CHOICES, type)
        click(BTN_SAVE_PHONE)
        wait_for_spinner
    end

    def remove_phone_number
        click(EDIT_PHONE)
        sleep_for(1) # slide in animation!
        if is_present?(BTN_REMOVE_PHONE)
            click(BTN_REMOVE_PHONE)
            click(BTN_REMOVE_CONFIRM)
            wait_for_spinner
        end
        click(BTN_CLOSE)
    end

    def switch_phone_preferrences
        click(EDIT_PHONE)
        sleep_for(1) # slide in animation!
        if !is_present?(INPUT_PHONE)
            click(ADD_PHONE)
        end
        click(PHONE_CHECKBOX_MESSAGE)
        click(PHONE_CHECKBOX_NOTIFICATION)
        click(BTN_SAVE_PHONE)
        wait_for_spinner
    end

    def add_email(email:) 
        click(EDIT_EMAIL)
        sleep_for(1) # slide in animation!
        click(ADD_EMAIL)
        enter(email, INPUT_EMAIL)
        click(BTN_SAVE_EMAIL)
        wait_for_spinner
    end

    def remove_email
        click(EDIT_EMAIL)
        sleep_for(1) # slide in animation!
        if is_present?(BTN_REMOVE_EMAIL)
            click(BTN_REMOVE_EMAIL)
            click(BTN_REMOVE_CONFIRM)
            wait_for_spinner
        end
        click(BTN_CLOSE)
    end

    def switch_email_preferrences
        click(EDIT_EMAIL)
        sleep_for(1) # slide in animation!
        if !is_present?(INPUT_EMAIL)
            click(ADD_EMAIL)
        end
        click(EMAIL_CHECKBOX_MESSAGE)
        click(EMAIL_CHECKBOX_NOTIFICATION)
        click(BTN_SAVE_EMAIL)
        wait_for_spinner
    end

    def close_modal
        click(BTN_CLOSE)
    end
  
    def change_contact_preferrences(method:, time:)
        click(EDIT_CONTACT_PREFERRENCES)
        sleep_for(1) # slide in animation!
        click(EXPAND_METHOD_CHOICES)
        click_element_from_list_by_text(LIST_METHOD_CHOICES, method)
        click(EXPAND_TIME_CHOICES)
        click_element_from_list_by_text(LIST_TIME_CHOICES, time)
    end


end  
 