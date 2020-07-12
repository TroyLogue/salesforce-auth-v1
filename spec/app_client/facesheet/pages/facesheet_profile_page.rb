require_relative '../../../shared_components/base_page'

class FacesheetProfilePage < BasePage

  FACESHEET_PROFILE = { css: '.facesheet-profile' }
  ERROR_MESSAGE = { css: '.dialog.open .ui-form-field__error' }
  BTN_CLOSE = { css: '.dialog.open .title.title-closeable > a ' }

  CURRENT_PHONE = { css: '.phone-number-display > p > a' }
  CURRENT_PHONE_NOTIFICATION = { css: '.phone-number-display .communication-additional-info' }
  EDIT_PHONE = { css: '#edit-phone-number-btn' }
  ADD_PHONE = { css: '#add-phone-link' }
  INPUT_PHONE = { css: 'input[id^="phoneNumber"]' }
  EXPAND_TYPE_CHOICES = { css: 'div[aria-activedescendant^="choices-phoneType"]' }
  LIST_TYPE_CHOICES = { css: 'div[id^="choices-phoneType"]' }
  PHONE_CHECKBOX_MESSAGE = { css: '.profile-phone-fields div > input[id$="message"] + label' }
  PHONE_CHECKBOX_NOTIFICATION = { css: '.profile-phone-fields div > input[id$="notification"] + label' }
  BTN_SAVE_PHONE = { css: '#edit-phone-number-save-btn' }
  BTN_REMOVE_PHONE = { css: '.remove-phone-button' }
  BTN_REMOVE_CONFIRM = { css: '.confirm-confirmation' }

  CURRENT_EMAIL = { css: '.email > p > a' }
  CURRENT_EMAIL_NOTIFiCATION = { css: '.email .communication-additional-info' }
  EDIT_EMAIL = { css: '#edit-email-btn' }
  ADD_EMAIL = { css: '#add-email-link' }
  INPUT_EMAIL = { css: 'input[name="emails[0].email_address"]' }
  EMAIL_CHECKBOX_MESSAGE = { css: '.inline-email-address div > input[id$="message"] + label' }
  EMAIL_CHECKBOX_NOTIFICATION = { css: '.inline-email-address  div > input[id$="notification"] + label' }
  BTN_SAVE_EMAIL = { css: '#edit-email-save-btn' }
  BTN_REMOVE_EMAIL = { css: '.remove-email-button' }

  EDIT_CONTACT_PREFERENCES = { css: '#edit-contact-preferences-btn' }
  EXPAND_METHOD_CHOICES = { css: 'div[aria-activedescendant^="choices-preferred-method-of-contact-field-item-choice"]' }
  LIST_METHOD_CHOICES = { css: 'div[id^="choices-preferred-method-of-contact-field-item-choice"]' }
  EXPAND_TIME_CHOICES = { css: 'div[aria-activedescendant^="choices-best-time-to-contact-field-item-choice"]' }
  LIST_TIME_CHOICES = { css: 'div[id^="choices-best-time-to-contact-field-item-choice"]' }
  BTN_SAVE_PREFERENCES = { css: '#edit-communication-preferences-save-btn' }

  BLANK_FIELD_ERROR_MESSAGE = 'Required'
  INVALID_PHONE_ERROR_MESSAGE = 'Must be at least 10 digits'
  ENABLED_NOTIFICATION_MESSAGE = '(message, notification)'
  PHONE_TYPE_MOBILE = 'Mobile'
  PHONE_TYPE_HOME = 'Home'
  PHONE_TYPE_WORK = 'Work'
  PHONE_TYPE_FAX = 'Fax'
  PHONE_TYPE_UNKNOWN = 'Unknown'

  def page_displayed?
    is_displayed?(FACESHEET_PROFILE)
  end

  def is_required_error_message_displayed?
    text(ERROR_MESSAGE) == BLANK_FIELD_ERROR_MESSAGE
  end

  def close_modal
    click(BTN_CLOSE)
  end

  #Phone section
  def get_current_phone_number
    text(CURRENT_PHONE)
  end

  def are_phone_notifications_enabled?
    text(CURRENT_PHONE_NOTIFICATION) == ENABLED_NOTIFICATION_MESSAGE
  end

  def add_mobile_phone_number_with_enabled_notifications(phone:)
    click(EDIT_PHONE)
    sleep_for(1) # slide in animation!
    #Adding Phone Number
    click(ADD_PHONE)
    click(INPUT_PHONE)
    enter(phone, INPUT_PHONE)
    click(EXPAND_TYPE_CHOICES)
    click_element_from_list_by_text(LIST_TYPE_CHOICES, PHONE_TYPE_MOBILE)
    #Enabling notifications
    click(PHONE_CHECKBOX_MESSAGE)
    click(PHONE_CHECKBOX_NOTIFICATION)
    #saving
    click(BTN_SAVE_PHONE)
    wait_for_spinner
    wait_for_notification_to_disappear
  end

  def enable_phone_notifications_on_blank_field
    click(EDIT_PHONE)
    sleep_for(1) # slide in animation!
    #Not adding phone number
    click(ADD_PHONE)
    #Enabling notifications
    click(PHONE_CHECKBOX_MESSAGE)
    click(PHONE_CHECKBOX_NOTIFICATION)
    #saving
    click(BTN_SAVE_PHONE)
  end

  # Email Section
  def get_current_email
    text(CURRENT_EMAIL)
  end

  def are_email_notifications_enabled?
    text(CURRENT_EMAIL_NOTIFiCATION) == ENABLED_NOTIFICATION_MESSAGE
  end

  def add_email_with_enabled_notifications(email:)
    click(EDIT_EMAIL)
    sleep_for(1) # slide in animation!
    #Adding email
    click(ADD_EMAIL)
    enter(email, INPUT_EMAIL)
    #Enabling notifications
    click(EMAIL_CHECKBOX_MESSAGE)
    click(EMAIL_CHECKBOX_NOTIFICATION)
    #saving
    click(BTN_SAVE_EMAIL)
    wait_for_spinner
    wait_for_notification_to_disappear
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

  def enable_email_notifications_on_blank_field
    click(EDIT_EMAIL)
    sleep_for(1) # slide in animation!
    #Not adding email
    click(ADD_EMAIL)
    #Enabling notifications
    click(EMAIL_CHECKBOX_MESSAGE)
    click(EMAIL_CHECKBOX_NOTIFICATION)
    #saving
    click(BTN_SAVE_EMAIL)
  end

  def change_contact_preferences(method:, time:)
    click(EDIT_CONTACT_PREFERENCES)
    sleep_for(1) # slide in animation!
    click(EXPAND_METHOD_CHOICES)
    click_element_from_list_by_text(LIST_METHOD_CHOICES, method)
    click(EXPAND_TIME_CHOICES)
    click_element_from_list_by_text(LIST_TIME_CHOICES, time)
  end

  # Intended to be used for cleaning up of profile fields when re-using a client
  def remove_profile_email_phone_fields_if_present
    #Phone
    click(EDIT_PHONE)
    sleep_for(1) # slide in animation!

    if is_present?(BTN_REMOVE_PHONE)
      click(BTN_REMOVE_PHONE)
      click(BTN_REMOVE_CONFIRM)
      wait_for_spinner
    end
    click(BTN_CLOSE)

    #Email
    click(EDIT_EMAIL)
    sleep_for(1) # slide in animation!
    if is_present?(BTN_REMOVE_EMAIL)
      click(BTN_REMOVE_EMAIL)
      click(BTN_REMOVE_CONFIRM)
      wait_for_spinner
    end
    click(BTN_CLOSE)
  end

end
