# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

module UserSettings
  class AccountInfoPage < BasePage
    SETTINGS_DIV = { css: '#user-settings-tabs' }.freeze

    # personal info
    PERSONAL_INFO_ROW = { css: '.user-personal-information.editable-panel' }.freeze
    NAME_AND_TITLE_ROW = { css: '.user-personal-information .col-sm-9' }.freeze
    EDIT_PERSONAL_INFO_BUTTON = { css: '#edit-personal-btn' }.freeze
    EDIT_PERSONAL_INFO_MODAL = { css: '#edit-personal-modal' }.freeze
    EDIT_WORK_TITLE_INPUT = { css: '#work-title' }.freeze
    SAVE_PERSONAL_INFO_BUTTON = { css: '#save-personal-information-btn' }.freeze

    # contact info
    CONTACT_INFO_ROW = { css: '.row.settings-contact-information' }.freeze

    # security settings
    EDIT_SECURITY_SETTINGS_BUTTON = { css: 'button[data-qa=edit-security-settings-btn]' }.freeze

    def load_page
      get('/user/settings')
    end

    def page_displayed?
      is_displayed?(SETTINGS_DIV) &&
        is_displayed?(PERSONAL_INFO_ROW) &&
        is_displayed?(CONTACT_INFO_ROW) &&
        is_displayed?(EDIT_SECURITY_SETTINGS_BUTTON)
    end

    def click_edit_security_settings
      click(EDIT_SECURITY_SETTINGS_BUTTON)
    end

    def edit_work_title(text)
      click_edit_personal_info
      find_edit_personal_info_modal
      enter_work_title(text)
      save_personal_info
    end

    def name_and_title
      text(NAME_AND_TITLE_ROW)
    end

    def personal_info_modal_not_displayed?
      is_not_displayed?(EDIT_PERSONAL_INFO_MODAL, 0.5)
    end

    private

    def click_edit_personal_info
      click(EDIT_PERSONAL_INFO_BUTTON)
    end

    def find_edit_personal_info_modal
      find(EDIT_PERSONAL_INFO_MODAL)
    end

    def enter_work_title(text)
      clear_then_enter(text, EDIT_WORK_TITLE_INPUT)
    end

    def save_personal_info
      click(SAVE_PERSONAL_INFO_BUTTON)
    end
  end
end
