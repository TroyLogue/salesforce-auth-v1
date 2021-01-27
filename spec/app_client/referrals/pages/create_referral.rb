module CreateReferral
  class AddReferral < BasePage
    THIRD_STEP = { css: '.MuiStep-root:nth-of-type(5) > button .MuiStepLabel-active' }.freeze
    REFERRAL_FORM = { css: '.referral-service-form-expanded' }.freeze
    INFO_TEXT = { css: '.info-panel__text' }.freeze

    EXPAND_SERVICE_CHOICES = { css: '.service-type-dropdown' }.freeze
    FIRST_SERVICE_CHOICE = { css: '#choices-service-type-item-choice-2' }.freeze
    SELECTED_SERVICE_TYPE = { css: '#service-type + div > div:not(button)' }.freeze
    BROWSE_MAP_LINK = { css: '#browse-map-button' }.freeze

    ADD_ANOTHER_RECIPIENT = { css: 'button[aria-label="+ ADD ANOTHER RECIPIENT"]' }.freeze
    AUTO_RECALL_CHECKBOX = { css: '#send-referral-auto-recallable-checkbox-0 + label' }.freeze
    ERROR_MESSAGE = { css: '.field-error-message > p' }.freeze

    DESCRIPTION_TEXT = { css: '#referral-notes' }.freeze
    SAVE_DRAFT_BTN = { css: '#save-draft-btn' }.freeze
    NEXT_BTN = { css: '#next-btn' }.freeze

    REMOVE_TEXT = 'Remove item'.freeze
    WARNING_REGULAR = 'Only include personally identifiable information (PII), protected health information (PHI), or other sensitive information if it is necessary to provide services to the client.'.freeze
    WARNING_SENSITIVE = 'If this referral is for a 42 CFR Part 2 covered service, Part 2 prohibits the unauthorized re-disclosure of these records.'.freeze

    ERROR_MULTIPLE_RECIPIENT_CC = 'A referral with multiple recipients cannot include a Coordination Center. Refer to a Coordination Center only if you are uncertain about which organization(s) can serve your client.'.freeze

    def page_displayed?
      # Initializing recipient for locators
      @recipient_index = 0
      wait_for_spinner
      is_displayed?(THIRD_STEP) &&
        is_displayed?(REFERRAL_FORM) &&
        is_displayed?(INFO_TEXT)
    end

    def warning_info_text
      text(INFO_TEXT)
    end

    def select_first_service_type
      click(EXPAND_SERVICE_CHOICES)
      click(FIRST_SERVICE_CHOICE)
      wait_for_spinner
      text(SELECTED_SERVICE_TYPE).sub(REMOVE_TEXT, '').strip.capitalize
    end

    def open_network_browse_map
      click(BROWSE_MAP_LINK)
    end

    def select_first_org
      org_choices = { css: "#select-field-group-#{@recipient_index} + .choices__list" }
      first_org_choice = { css: "div[id^='choices-select-field-group-#{@recipient_index}-item-choice']:not([aria-disabled*='true']):not([data-value=''])" }
      selected_org = { css: "#select-field-group-#{@recipient_index} + div > div:not(button)" }

      click(org_choices)
      click(first_org_choice)

      if is_displayed?(ERROR_MESSAGE, 2) && text(ERROR_MESSAGE) == ERROR_MULTIPLE_RECIPIENT_CC
        info_message = 'Users are unable to add a Coordination Center when there are multiple recipients. '\
                       'One of the providers selected is a Coordination Center.'
        raise StandardError, info_message
      end

      # Removing distance and "Remove Item" to return just the provider name
      provider = text(selected_org)
      provider_distance = provider.rindex(/\(/) # finds the last open paren in the string
      provider[0..(provider_distance - 1)].strip # returns provider_text up to the distance
    end

    def select_first_program
      select_program_link = { css: ".referral-program-selected__add-program-#{@recipient_index}" }
      program_choices = { css: "div[aria-activedescendant^='choices-select-field-program-#{@recipient_index}-item-choice']" }
      first_program_choice = { css: "div[id^='choices-select-field-program-#{@recipient_index}-item-choice']" }
      selected_program = { css: "#select-field-program-#{@recipient_index} + div > div:not(button)" }

      click(select_program_link)
      click(program_choices)
      click(first_program_choice)
      text(selected_program).sub(REMOVE_TEXT, '').strip
    end

    def add_another_recipient
      click(ADD_ANOTHER_RECIPIENT)
      @recipient_index += 1
      org_choices = { css: "#select-field-group-#{@recipient_index} + .choices__list" }

      is_displayed?(org_choices)
    end

    def add_multiple_recipients(count:)
      recipient_info = ''
      count.times do
        provider = select_first_org
        program = select_first_program
        recipient_info << "#{provider} - #{program}"
        add_another_recipient
      end
      recipient_info
    end

    def click_auto_recall_checkbox
      click(AUTO_RECALL_CHECKBOX)
    end

    def fill_out_referral_description(description:)
      enter(description, DESCRIPTION_TEXT)
    end

    def click_next_button
      click(NEXT_BTN)
    end

    def click_save_draft_button
      click(SAVE_DRAFT_BTN)
    end
  end

  class AdditionalInfo < BasePage
    THIRD_STEP = { css: '.MuiStep-root:nth-of-type(5) > button .MuiStepLabel-active' }.freeze
    NEXT_BTN = { css: '#next-btn' }.freeze

    def page_displayed?
      wait_for_spinner
      is_displayed?(THIRD_STEP) &&
        is_displayed?(NEXT_BTN)
    end

    def click_next_button
      click(NEXT_BTN)
    end
  end

  class FinalReview < BasePage
    FOURTH_STEP = { css: '.MuiStep-root:nth-of-type(7) > button .MuiStepLabel-active' }.freeze
    REFERRAL_FORM = { css: '.referral-review' }.freeze

    SERVICE_TYPE = { css: '.referral-service-minimized__header-text' }.freeze
    DESCRIPTION = { css: '.detail-info__description-text' }.freeze
    RECIPIENTS = { css: '.service-type-section:nth-of-type(2) .detail-info__groups-list > li' }.freeze
    FULL_NAME = { css: '.detail-definition-list__value' }.freeze

    SUBMIT_BTN = { css: '#submit-referral-btn' }.freeze

    def page_displayed?
      is_displayed?(FOURTH_STEP) &&
        is_displayed?(REFERRAL_FORM)
    end

    def service_type
      text(SERVICE_TYPE).capitalize
    end

    def description
      text(DESCRIPTION)
    end

    def recipients
      find_elements(RECIPIENTS).collect { |ele| ele.text.sub('undefined', '').strip }.join('')
    end

    def full_name
      text(FULL_NAME)
    end

    def click_submit_button
      click(SUBMIT_BTN)
    end
  end
end
