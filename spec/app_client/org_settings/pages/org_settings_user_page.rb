# frozen_string_literal: true

require_relative '../../root/pages/notifications'

module OrgSettings
  class UserTable < BasePage
    USER_TABLE = { css: '.ui-table > table > tbody > tr > td > a' }.freeze
    USER_TABLE_LOAD = { xpath: './/tbody/tr/td[text()="Loading"]' }.freeze
    USER_NAME_LIST = { css: '.ui-table-body > tr > td:nth-child(1) > a' }.freeze
    USER_EMAIL_LIST = { css: '.ui-table-body > tr > td:nth-child(2)' }.freeze
    USER_ROW_FIRST = { css: '.employee-table-row:nth-of-type(1) .ui-table-row-column' }.freeze

    ADD_USER_BTN = { css: '#add-user-btn' }.freeze
    USERS_TABLE = { css: '.ui-table-body' }.freeze
    USERS_SEARCH_BOX = { css: '#search-text' }.freeze

    def page_displayed?
      wait_for_table_load
      is_displayed?(USER_TABLE)
    end

    def wait_for_table_load
      is_not_displayed?(USER_TABLE_LOAD)
    end

    def get_list_of_user_names
      names = find_elements(USER_NAME_LIST)
      names.collect(&:text)
    end

    def get_list_of_user_emails
      emails = find_elements(USER_EMAIL_LIST)
      emails.collect(&:text)
    end
 
    def go_to_first_user
      click(USER_ROW_FIRST)
      wait_for_spinner
    end

    def go_to_first_user
      click(USER_ROW_FIRST)
      wait_for_spinner
    end

    def go_to_new_user_form
      click(ADD_USER_BTN)
    end

    def search_for(text)
      enter(text, USERS_SEARCH_BOX)
    end

    def no_users_displayed?
      is_not_displayed?(USER_ROW_FIRST)
    end

    def users_displayed?
      is_displayed?(USER_ROW_FIRST)
    end

    def matching_users_displayed?(text)
      names_and_emails = get_list_of_user_names.zip(get_list_of_user_emails)
      users_displayed? && names_and_emails.all? { |name_and_email| name_and_email.any? { |val| val.include?(text) } }
    end
  end

  class UserCard < BasePage
    USER_HEADER = { css: '.ui-base-card-header__title' }.freeze
    NAME_AND_TITLE_ROW = { css: '.common-display-profile.editable-panel' }.freeze

    # NEW USER
    INPUT_FIRSTNAME = { css: '#first-name' }.freeze
    INPUT_LASTNAME = { css: '#last-name' }.freeze
    INPUT_EMAIL = { css: 'input[type="email"]' }.freeze
    INPUT_PHONE = { css: '#phone-number-0-number' }.freeze
    INPUT_WORK_TITLE = { css: '#work-title' }.freeze
    EMPLOYEE_STATE_CHOICES = { css: 'div[aria-activedescendant*="choices-state-item-choice"]' }.freeze
    EMPLOYEE_STATE_ACTIVE = { css: 'div[aria-activedescendant*="choices-state-item-choice"] .choices__item.choices__item--selectable[data-value="active"]' }.freeze
    INPUT_PROGRAM_CHOICES = { css: 'div[aria-activedescendant*="programs-item-choice"]' }.freeze
    INPUT_PROGRAM_ROLES = { css: 'div[aria-activedescendant*="roles-item-choice"]' }.freeze
    INPUT_ORG_ROLES = { css: 'div[aria-activedescendant*="org-roles-item-choice"]' }.freeze

    # EXISTING USER
    EDITABLE_PERSONAL_INFO = { css: '#edit-personal-information-modal-btn' }.freeze
    BTN_CANCEL_PERSONAL = { css: '#personal-information-cancel-btn' }.freeze
    EDIT_PERSONAL_INFO_MODAL = { css: '#edit-personal-information-modal' }.freeze
    EDIT_PERSONAL_INFO_CLOSE_BUTTON = { css: '#edit-personal-information-modal .title-closeable .ui-icon' }.freeze
    EDIT_PERSONAL_INFO_SAVE_BUTTON = { css: '#edit-personal-information-modal #personal-information-submit-btn' }.freeze
    EDITABLE_EMAIL = { css: '#edit-email-address-modal-btn' }.freeze
    BTN_SAVE_EMAIL = { css: '#edit-email-save-btn' }.freeze
    EDIT_EMAIL_CLOSE_BUTTON = { css: '#edit-email-address-modal .title-closeable .ui-icon' }.freeze
    BTN_CANCEL_EMAIL = { css: '#edit-email-cancel-btn' }.freeze
    EDITABLE_PROGRAM = { css: '#edit-program-information-modal-btn' }.freeze
    BTN_CANCEL_PROGRAM = { css: '#program-data-cancel-btn' }.freeze
    EDIT_PROGRAM_CLOSE_BUTTON = { css: '#edit-program-information-modal .title-closeable .ui-icon' }.freeze
    EDITABLE_NETWORK = { css: '#edit-network-licenses-modal-btn' }.freeze
    EDITABLE_ORG = { css: '#dit-group-licenses-modal-btn' }.freeze


    def get_user_title
      text(USER_HEADER)
    end

    def new_user_fields_display?
      is_displayed?(INPUT_FIRSTNAME) && is_displayed?(INPUT_LASTNAME) && is_displayed?(INPUT_EMAIL) &&
        is_displayed?(INPUT_PHONE) && is_displayed?(INPUT_WORK_TITLE) && is_displayed?(EMPLOYEE_STATE_CHOICES) &&
        is_displayed?(INPUT_PROGRAM_CHOICES) && is_displayed?(INPUT_PROGRAM_ROLES) && is_displayed?(INPUT_ORG_ROLES)
    end

    def employee_state_active?
      is_displayed?(EMPLOYEE_STATE_ACTIVE)
    end

    def existing_user_fields_editable?
      edit_personal_info? && edit_email_info? && edit_program_access?
    end

    def edit_personal_info?
      click(EDITABLE_PERSONAL_INFO)
      is_displayed?(EDIT_PERSONAL_INFO_CLOSE_BUTTON) # wait for modal to glide down
      editable = is_displayed?(INPUT_FIRSTNAME) && is_displayed?(INPUT_LASTNAME) && is_displayed?(INPUT_WORK_TITLE)
      click(BTN_CANCEL_PERSONAL)
      editable
    end

    def edit_email_info?
      click(EDITABLE_EMAIL)
      is_displayed?(EDIT_EMAIL_CLOSE_BUTTON) # wait for modal to glide down
      editable = is_displayed?(INPUT_EMAIL)
      click(BTN_CANCEL_EMAIL)
      editable
    end

    def edit_program_access?
      click(EDITABLE_PROGRAM)
      is_displayed?(EDIT_PROGRAM_CLOSE_BUTTON) # wait for modal to glide down
      editable = is_displayed?(INPUT_PROGRAM_CHOICES) && is_displayed?(INPUT_PROGRAM_ROLES) && is_displayed?(INPUT_ORG_ROLES)
      click(BTN_CANCEL_PROGRAM)
      editable
    end

    def save_email_field
      click(EDITABLE_EMAIL)
      is_displayed?(EDIT_EMAIL_CLOSE_BUTTON) # wait for modal to glide down
      is_displayed?(INPUT_EMAIL)
      click(BTN_SAVE_EMAIL)
      is_not_displayed?(INPUT_EMAIL)
    end

    def edit_personal_info(first_name: nil, last_name: nil, work_title: nil)
      click(EDITABLE_PERSONAL_INFO)
      is_displayed?(EDIT_PERSONAL_INFO_CLOSE_BUTTON) # wait for modal to glide down
      clear_then_enter(first_name, INPUT_FIRSTNAME) unless first_name.nil?
      clear_then_enter(last_name, INPUT_LASTNAME) unless last_name.nil?
      clear_then_enter(work_title, INPUT_WORK_TITLE) unless work_title.nil?
      click(EDIT_PERSONAL_INFO_SAVE_BUTTON)
    end

    def personal_info_modal_not_displayed?
      is_not_displayed?(EDIT_PERSONAL_INFO_MODAL, 0.5)
    end

    def name_and_title
      text(NAME_AND_TITLE_ROW)
    end
  end
end
