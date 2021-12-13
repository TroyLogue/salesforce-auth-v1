# frozen_string_literal: true

module ContactComponents

  INPUTS_PHONE_NUMBER = { css: '[data-test-element^=phone_number_]' }
  INPUTS_PHONE_TYPE = { css: '[data-test-element^=phone_type_]' }
  REMOVE_BUTTONS_PHONE = { css: '[data-test-element^=phone_trash_' }

  INPUT_PHONE_NUMBER_FIRST = { css: 'input[id=org-phone-0]' }
  INPUT_PHONE_TYPE_FIRST = { css: '[data-test-element=phone_type_0]' }
  REMOVE_BUTTON_PHONE_FIRST = { css: '[data-test-element=phone_trash_0' }

  PHONE_TYPE_SELECT_LIST = { css: '[id="org-phone-type-0"] + .choices__list' }.freeze
  PHONE_TYPE_CHOICES = { css: '[id^="choices-org-phone-type-0"]' }.freeze
  PHONE_TYPE_FAX = 'Fax'

  INPUTS_EMAIL = { css: '[data-test-element^=email_]' }
  REMOVE_BUTTONS_EMAIL = { css: '[data-test-element^=email_trash_' }

  INPUT_EMAIL_FIRST = { css: 'input[id=org-email-0]' }
  REMOVE_BUTTON_EMAIL_FIRST = { css: '[data-test-element=email_trash_0' }

  INPUT_HOURS_DAY_FIRST = { css: '[id="org-hours-day-0"]' }
  INPUT_HOURS_OPEN_FIRST = { css: '[id="org-hours-starts-0"]' }
  INPUT_HOURS_CLOSE_FIRST = { css: '[id="org-hours-ends-0"]' }
  LIST_HOURS = { css: '[id^="choices-org-hours-starts-0"]' }.freeze
  REMOVE_BUTTON_HOURS_FIRST = { css: '[data-test-element=hours_trash_0]' }

  ADD_PHONE_BUTTON = { css: '[data-test-element=add_phone]' }.freeze
  ADD_EMAIL_BUTTON = { css: '[data-test-element=add_email]' }.freeze
  ADD_HOURS_BUTTON = { css: '[data-test-element=add_hours]' }.freeze

end
