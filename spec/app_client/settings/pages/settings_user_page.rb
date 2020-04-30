require_relative '../../root/pages/notifications'

module Settings

    class UserTable < BasePage
        USER_TABLE = { css: '.ui-table > table > tbody > tr > td > a' }
        USER_TABLE_LOAD = { xpath: ".//tbody/tr/td[text()='Loading']" }
        USER_LIST  = { css: '.ui-table-body > tr > td:nth-child(1) > a' }
        USER_NAME = { xpath: ".//*[@class='ui-table-body']/tr/td/a[text()='%s']" }
        ADD_USER_BTN = { css: '#add-user-btn' }

        def page_displayed?
            wait_for_table_load
            is_displayed?(USER_TABLE)
        end

        def wait_for_table_load
            is_not_displayed?(USER_TABLE_LOAD)
        end

        def get_list_of_user_names
            names = find_elements(USER_LIST)
            names_array = names.collect(&:text)
        end

        def go_to_user(name:)
            click(USER_NAME.transform_values{|v| v % name})
            wait_for_spinner
        end
        
        def go_to_new_user_form
            click(ADD_USER_BTN)
        end
    end

    class UserCard < BasePage
        USER_HEADER = { css: '.ui-base-card-header__title'}

        #NEW USER
        INPUT_FIRSTNAME = { css: '#first-name' }
        INPUT_LASTNAME = { css: '#last-name' }
        INPUT_EMAIL = { css: 'input[type="email"]' }
        INPUT_PHONE = { css: '#phone-number-0-number' }
        INPUT_WORK_TITLE = { css: '#work-title' }
        INPUT_NETWORKS = { css: 'div[aria-activedescendant^="choices-networks-item-choice"]' }
        INPUT_ORG_LICENSE = { css: 'div[aria-activedescendant^="choices-org-license-item-choice"]' }
        INPUT_PROGRAM_CHOICES = { css: 'div[aria-activedescendant*="programs-item-choice"]' }
        INPUT_PROGRAM_ROLES = { css: 'div[aria-activedescendant*="roles-item-choice"]' }
        INPUT_ORG_ROLES = { css: 'div[aria-activedescendant*="org-roles-item-choice"]' }

        #EXISTING USER
        EDITABLE_PERSONAL_INFO = { css: '#edit-personal-information-modal-btn' }
        BTN_CANCEL_PERSONAL = { css: '#personal-information-cancel-btn' }
        EDITABLE_EMAIL = { css: '#edit-email-address-modal-btn' }
        BTN_SAVE_EMAIL = { css: '#edit-email-save-btn' }
        BTN_CANCEL_EMAIL = { css: '#edit-email-cancel-btn' }
        EDITABLE_PROGRAM =  { css: '#edit-program-information-modal-btn' }
        BTN_CANCEL_PROGRAM = { css: '#program-data-cancel-btn' }
        EDITABLE_NETWORK = { css: '#edit-network-licenses-modal-btn' }
        EDITABLE_ORG = { css: '#dit-group-licenses-modal-btn' }

        def get_user_title
            text(USER_HEADER)
        end

        def new_user_fields_display?
            is_displayed?(INPUT_FIRSTNAME) && is_displayed?(INPUT_LASTNAME) && is_displayed?(INPUT_EMAIL) && is_displayed?(INPUT_PHONE) &&
            is_displayed?(INPUT_WORK_TITLE) && is_displayed?(INPUT_NETWORKS) && is_displayed?(INPUT_ORG_LICENSE) && 
            is_displayed?(INPUT_PROGRAM_CHOICES) && is_displayed?(INPUT_PROGRAM_ROLES) && is_displayed?(INPUT_ORG_ROLES)
        end

        def existing_user_fields_editable?
            edit_personal_info? && edit_email_info? && edit_program_access?
        end

        def edit_personal_info?
            click(EDITABLE_PERSONAL_INFO)
            sleep_for(1) #glide in animation
            editable = is_displayed?(INPUT_FIRSTNAME) && is_displayed?(INPUT_LASTNAME) && is_displayed?(INPUT_WORK_TITLE)
            click(BTN_CANCEL_PERSONAL)
            editable
        end

        def edit_email_info?
            click(EDITABLE_EMAIL)
            sleep_for(1) #glide in animation
            editable = is_displayed?(INPUT_EMAIL)
            click(BTN_CANCEL_EMAIL)
            editable
        end

        def edit_program_access?
            click(EDITABLE_PROGRAM)
            sleep_for(1) #glide in animation
            editable = is_displayed?(INPUT_PROGRAM_CHOICES) && is_displayed?(INPUT_PROGRAM_ROLES) && is_displayed?(INPUT_ORG_ROLES)
            click(BTN_CANCEL_PROGRAM)
            editable
        end

        def save_email_field?
            click(EDITABLE_EMAIL)
            sleep_for(1) #glide in animation
            is_displayed?(INPUT_EMAIL)
            click(BTN_SAVE_EMAIL)
            is_not_displayed?(INPUT_EMAIL)
            is_displayed?(Notifications::SUCCESS_BANNER)
        end
    end

end
