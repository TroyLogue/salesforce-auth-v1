module Settings

    class OrganizationProfile < BasePage

        DIALOG_MODEL = { css: '.dialog.open' }
        SUCCESS_HEADER = { css: '.notification.success' }
        CLOSE_HEADER = { css: '.close'}
        EDIT_DESCRIPTION = { css: '#edit-description-btn' }
        SAVE_DESCRIPTION = { css: '#edit-description-save-btn' }
        EDIT_PHONE = { css: '#edit-phone-number-btn' }
        SAVE_PHONE = { css: '#edit-phone-number-save-btn' }
        EDIT_EMAIL = { css: '#edit-email-btn' }
        SAVE_EMAIL = { css: '#edit-email-save-btn' }
        EDIT_ADDRESS = { css: '#edit-address-btn' }
        SAVE_ADDRESS = { css: '#edit-address-save-btn' }
        EDIT_WEBSITE = { css: '#edit-website-btn' }
        SAVE_WEBSITE = { css: '#edit-url-modal-save-btn' }
        EDIT_HOURS = { css: '#edit-hours-btn' }
        SAVE_HOURS = { css: '#edit-hours-modal-save-btn' }

        def page_displayed?
            is_displayed?(EDIT_DESCRIPTION)
        end

        def save_all_profile_fields
            description = save_field(edit_button: EDIT_DESCRIPTION , save_button: SAVE_DESCRIPTION)
            click_within(SUCCESS_HEADER, CLOSE_HEADER)

            phone = save_field(edit_button: EDIT_PHONE , save_button: SAVE_PHONE)
            click_within(SUCCESS_HEADER, CLOSE_HEADER)

            email = save_field(edit_button: EDIT_EMAIL , save_button: SAVE_EMAIL)
            click_within(SUCCESS_HEADER, CLOSE_HEADER)

            addresss = save_field(edit_button: EDIT_ADDRESS , save_button: SAVE_ADDRESS)
            click_within(SUCCESS_HEADER, CLOSE_HEADER)

            website = save_field(edit_button: EDIT_WEBSITE , save_button: SAVE_WEBSITE)
            click_within(SUCCESS_HEADER, CLOSE_HEADER)

            hours = save_field(edit_button: EDIT_HOURS , save_button: SAVE_HOURS)
            click_within(SUCCESS_HEADER, CLOSE_HEADER)

            [description, phone, email, addresss, website, hours]
        end

        def save_field(edit_button:, save_button:)
            click(edit_button)
            sleep_for(1) #glide in animation
            is_displayed?(DIALOG_MODEL)
            click(save_button)
            is_field_saved?
        end

        def is_field_saved?
            #For a successful save, we expect the dialog model to not be present and a success banner
            is_not_displayed?(DIALOG_MODEL, 5) 
            is_displayed?(SUCCESS_HEADER)
        end
    end
end
