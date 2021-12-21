# frozen_string_literal: true

module OrgSettings
  module ContactComponents
    INPUT_PHONE_NUMBER_FIRST = { css: 'input[id$=phone-0]' }
    INPUT_PHONE_TYPE_FIRST = { css: '[data-test-element=phone_type_0]' }
    REMOVE_BUTTON_PHONE_FIRST = { css: '[data-test-element=phone_trash_0' }

    PHONE_TYPE_SELECT_LIST = { css: '[id$=phone-type-0] + .choices__list' }
    PHONE_TYPE_CHOICES = { css: '[id*=phone-type-0-item-choice]' }
    PHONE_TYPE_FAX = 'Fax'

    INPUT_EMAIL_FIRST = { css: 'input[id$=email-0]' }
    REMOVE_BUTTON_EMAIL_FIRST = { css: '[data-test-element=email_trash_0' }

    INPUT_HOURS_DAY_FIRST = { css: '[id=org-hours-day-0]' }
    INPUT_HOURS_OPEN_FIRST = { css: '[id=org-hours-starts-0]' }
    INPUT_HOURS_CLOSE_FIRST = { css: '[id=org-hours-ends-0]' }
    LIST_HOURS = { css: '[id^=choices-org-hours-starts-0]' }
    REMOVE_BUTTON_HOURS_FIRST = { css: '[data-test-element=hours_trash_0]' }

    ADD_PHONE_BUTTON = { css: '[data-test-element=add_phone]' }
    ADD_EMAIL_BUTTON = { css: '[data-test-element=add_email]' }
    ADD_HOURS_BUTTON = { css: '[data-test-element=add_hours]' }

    SAVE_BUTTON = { css: '[data-test-element=save]' }
  end
end
