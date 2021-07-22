module CreateReferral
  class AddReferral < BasePage
    THIRD_STEP = { css: '.MuiStep-root:nth-of-type(5) > button .MuiStepLabel-active' }.freeze
    REFERRAL_FORM = { css: '.referral-service-form-expanded' }.freeze
    INFO_TEXT = { css: '.info-panel__text' }.freeze

    REFER_OTHER_NETWORK_CHECKBOX = { css: '.refer-to-another-network-checkbox-0 label' }.freeze
    EXPAND_RECIPIENT_NETWORK_CHOICES = { css: '#recipient-network + div' }.freeze
    FIRST_RECIPIENT_NETWORK = { css: '#choices-recipient-network-item-choice-1' }.freeze
    SELECTED_RECIPIENT_NETWORK = { css: '#recipient-network + div > div:not(button)' }.freeze

    EXPAND_SERVICE_CHOICES = { css: '.ui-expandable__container--expanded .service-type-dropdown div.choices:not(.is-disabled)' }.freeze
    FIRST_SERVICE_CHOICE = { css: '.ui-expandable__container--expanded #choices-service-type-item-choice-2' }.freeze
    SELECTED_SERVICE_TYPE = { css: '.ui-expandable__container--expanded #service-type + div > div:not(button)' }.freeze
    BROWSE_MAP_LINK = { css: '#browse-map-button' }.freeze
    CREATE_OUT_OF_NETWORK_CASE_BUTTON = { css: '.ui-expandable__container--expanded #open-out-of-network-case-btn' }.freeze
    SHARE_BUTTON = { css: '#share-btn' }.freeze
    CREATE_CASE_BUTTON = { css: '#create-case-btn' }.freeze

    PRIMARY_WORKER_DROPDOWN = { css: '.ui-expandable__container--expanded #primary-worker + .choices__list' }.freeze
    PRIMARY_WORKER_FIRST_OPTION = { css: '.ui-expandable__container--expanded #choices-primary-worker-item-choice-2' }.freeze
    SAVE_BUTTON = { css: '#save-case-assessments-btn' }.freeze
    SELECTED_PRIMARY_WORKER = { css: '.ui-expandable__container--expanded #primary-worker + div > div:not(button)' }.freeze

    ENROLLED_DATE = { css: '.ui-expandable__container--expanded #program-entry' }.freeze

    ADD_ANOTHER_RECIPIENT = { css: 'button[aria-label="+ ADD ANOTHER RECIPIENT"]' }.freeze
    ADD_ANOTHER_OON_RECIPIENT = { css: '#add-another-oon-group-btn' }.freeze
    AUTO_RECALL_CHECKBOX = { css: '#send-referral-auto-recallable-checkbox-0 + label' }.freeze
    CUSTOM_ORG_INPUT = { css: '.referral-oon-group-select  .single-select-with-custom-value .choices__list.choices__list--dropdown.is-active .choices__input.choices__input--cloned' }.freeze
    ERROR_MESSAGE = { css: '.field-error-message > p' }.freeze
    FIRST_SELECTED_ORG = { css: '#select-field-group-0 + div > div:not(button)' }.freeze
    FIRST_SELECTED_OON_ORG = { css: '#select-field-oon-group-0 + div > div:not(button)' }.freeze
    SECOND_OON_ORG_CHOICE = { css: '#select-field-oon-group-1 + .choices__list' }.freeze
    SECOND_SELECTED_OON_ORG = { css: '#select-field-oon-group-1 + div > div:not(button)' }.freeze

    DESCRIPTION_TEXT = { css: '.ui-expandable__container--expanded #referral-notes' }.freeze
    SAVE_DRAFT_BTN = { css: '#save-draft-btn' }.freeze
    NEXT_BTN = { css: '#next-btn' }.freeze

    REMOVE_TEXT = 'Remove item'.freeze
    WARNING_REGULAR = 'Only include personally identifiable information (PII), protected health information (PHI), or other sensitive information if it is necessary to provide services to the client.'.freeze
    WARNING_SENSITIVE = 'If this referral is for a 42 CFR Part 2 covered service, Part 2 prohibits the unauthorized re-disclosure of these records.'.freeze

    ERROR_MULTIPLE_RECIPIENT_CC = 'A referral with multiple recipients cannot include a Coordination Center. Refer to a Coordination Center only if you are uncertain about which organization(s) can serve your client.'.freeze

    ADD_ANOTHER_REFERRAL = { css: '#add-another-referral-btn' }.freeze

    def add_another_referral
      click(ADD_ANOTHER_REFERRAL)
      wait_for_spinner
    end

    def add_custom_org(name:)
      click(ADD_ANOTHER_OON_RECIPIENT)
      enter_and_select_custom_oon_org(name: name)
    end

    def add_oon_case_selecting_first_options(description:)
      selected_service_type = select_first_service_type
      click_create_oon_case
      selected_oon_org = select_first_oon_org
      fill_out_referral_description(description: description)
      fill_out_enrolled_date
      select_first_primary_worker

      {
        service_type: selected_service_type,
        recipients: selected_oon_org,
        description: description
      }
    end

    def add_referral_selecting_first_options(description:, count: 1)
      fill_out_referral_description(description: description)
      {
        service_type: select_first_service_type,
        recipients: add_multiple_in_network_recipients(count: count),
        description: description
      }
    end

    def can_add_another_referral?
      check_displayed?(ADD_ANOTHER_REFERRAL)
    end

    def click_auto_recall_checkbox
      click(AUTO_RECALL_CHECKBOX)
    end

    def click_create_case
      click(CREATE_CASE_BUTTON)
    end

    def click_next_button
      click(NEXT_BTN)
    end

    def click_save_draft_button
      click(SAVE_DRAFT_BTN)
    end

    def click_share
      click(SHARE_BUTTON)
    end

    def fill_out_enrolled_date
      formatted_date = Date.today.strftime('%d%m%y')
      enter(formatted_date, ENROLLED_DATE)
    end

    def open_network_browse_map
      click(BROWSE_MAP_LINK)
    end

    def page_displayed?
      # Initializing recipient for locators
      @recipient_index = 0
      wait_for_spinner
      is_displayed?(THIRD_STEP) &&
        is_displayed?(REFERRAL_FORM) &&
        is_displayed?(INFO_TEXT)
    end

    def refer_to_another_network
      is_displayed?(REFER_OTHER_NETWORK_CHECKBOX)
      click(REFER_OTHER_NETWORK_CHECKBOX)

      is_displayed?(EXPAND_RECIPIENT_NETWORK_CHOICES)
      click(EXPAND_RECIPIENT_NETWORK_CHOICES)

      click(FIRST_RECIPIENT_NETWORK)
      is_displayed?(EXPAND_SERVICE_CHOICES)

      text(SELECTED_RECIPIENT_NETWORK).sub(REMOVE_TEXT, '').strip.capitalize
    end

    def selected_recipient(org: FIRST_SELECTED_ORG)
      # Removing distance and "Remove Item" to return just the provider name
      provider = text(org)
      provider_distance = provider.rindex(/\(/) # finds the last open paren in the string
      provider[0..(provider_distance - 1)].strip # returns provider_text up to the distance
    end

    def select_first_service_type
      click(EXPAND_SERVICE_CHOICES)
      click(FIRST_SERVICE_CHOICE)
      wait_for_spinner
      text(SELECTED_SERVICE_TYPE).sub(REMOVE_TEXT, '').strip.capitalize
    end

    def select_first_org
      org_choices = { css: ".ui-expandable__container--expanded #select-field-group-#{@recipient_index} + .choices__list" }
      first_org_choice = { css: ".ui-expandable__container--expanded div[id^='choices-select-field-group-#{@recipient_index}-item-choice']:not([aria-disabled*='true']):not([data-value=''])" }
      selected_org = { css: ".ui-expandable__container--expanded #select-field-group-#{@recipient_index} + div > div:not(button)" }

      click(org_choices)
      click(first_org_choice)

      if is_displayed?(ERROR_MESSAGE, 2) && text(ERROR_MESSAGE) == ERROR_MULTIPLE_RECIPIENT_CC
        info_message = 'Users are unable to add a Coordination Center when there are multiple recipients. '\
                       'One of the providers selected is a Coordination Center.'
        raise StandardError, info_message
      end
      selected_recipient(org: selected_org)
    end

    def selected_primary_worker
      text(SELECTED_PRIMARY_WORKER).sub(REMOVE_TEXT, '').strip
    end

    def warning_info_text
      text(INFO_TEXT)
    end

    private

    def add_another_recipient
      click(ADD_ANOTHER_RECIPIENT)
      @recipient_index += 1
      org_choices = { css: "#select-field-group-#{@recipient_index} + .choices__list" }

      is_displayed?(org_choices)
    end

    def add_multiple_in_network_recipients(count:)
      recipient_info = ''
      count.times do |index|
        provider = select_first_org
        program = select_first_program
        recipient_info << "#{provider} - #{program}"
        # don't add another recipient the last time
        add_another_recipient unless index == (count - 1)
      end
      recipient_info
    end

    def click_create_oon_case
      click(CREATE_OUT_OF_NETWORK_CASE_BUTTON)
      wait_for_spinner
    end

    def click_save_button
      click(SAVE_BUTTON)
    end

    def enter_and_select_custom_oon_org(name:)
      click(SECOND_OON_ORG_CHOICE)
      enter_and_return(name, CUSTOM_ORG_INPUT)
    end

    def fill_out_referral_description(description:)
      enter(description, DESCRIPTION_TEXT)
    end

    def save_button_displayed?
      is_displayed?(SAVE_BUTTON)
    end

    def select_first_oon_org
      org_choices = { css: ".ui-expandable__container--expanded #select-field-oon-group-#{@recipient_index} + .choices__list" }
      first_org_choice = { css: ".ui-expandable__container--expanded div[id^='choices-select-field-oon-group-#{@recipient_index}-item-choice']:not([aria-disabled*='true']):not([data-value=''])" }
      selected_org = { css: ".ui-expandable__container--expanded #select-field-oon-group-#{@recipient_index} + div > div:not(button)" }

      click(org_choices)
      click(first_org_choice)

      if is_displayed?(ERROR_MESSAGE, 2) && text(ERROR_MESSAGE) == ERROR_MULTIPLE_RECIPIENT_CC
        info_message = 'Users are unable to add a Coordination Center when there are multiple recipients. '\
                       'One of the providers selected is a Coordination Center.'
        raise StandardError, info_message
      end

      selected_recipient(org: selected_org)
    end

    def select_first_primary_worker
      click(PRIMARY_WORKER_DROPDOWN)
      click(PRIMARY_WORKER_FIRST_OPTION)
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
  end

  class ShareDrawer < BasePage
    OPENED_DRAWER = { css: '.ui-drawer--opened.share-drawer' }.freeze
    CLOSE_BUTTON = { css: '.ui-drawer__close-btn--opened.share-drawer' }.freeze
    SHARE_LIST = { css: '.share-drawer-list' }.freeze
    SHARE_HEADER = { css: '.ui-drawer__title + .share-drawer__header' }.freeze

    RADIO_BUTTON_EMAIL = { css: '#email-label' }.freeze
    RADIO_BUTTON_PRINT = { css: '#print-label' }.freeze
    RADIO_BUTTON_TEXT = { css: '#sms-label' }.freeze

    INPUT_FIELD_EMAIL = { css: '#share-email-field' }.freeze
    INPUT_FIELD_TEXT = { css: '#share-phone-field' }.freeze

    SHARE_PRINT_BUTTON = { css: '#share-print-button' }.freeze
    SHARE_SEND_BUTTON = { css: '#share-send-button' }.freeze

    def drawer_displayed?
      is_displayed?(OPENED_DRAWER) &&
        is_displayed?(CLOSE_BUTTON)
    end

    def drawer_closed?
      !is_present?(OPENED_DRAWER)
    end

    def click_share_method(method:)
      case method
      when 'email'
        click(RADIO_BUTTON_EMAIL)
      when 'print'
        click(RADIO_BUTTON_PRINT)
      when 'text'
        click(RADIO_BUTTON_TEXT)
      else
        raise 'Missing method: expected email, print, or text'
      end
    end

    def form_displayed?(method:)
      case method
      when 'email'
        is_displayed?(INPUT_FIELD_EMAIL) &&
          is_displayed?(SHARE_SEND_BUTTON)
      when 'print'
        is_displayed?(SHARE_PRINT_BUTTON)
      when 'text'
        is_displayed?(INPUT_FIELD_TEXT) &&
          is_displayed?(SHARE_SEND_BUTTON)
      else
        raise 'Missing method: expected email, print, or text'
      end
    end

    def provider_header_count
      str = text(SHARE_HEADER)
      str.delete_prefix('Share').sub(/Org+\w+/, '').strip.to_i
    end

    def provider_list
      text(SHARE_LIST)
    end

    def share_by_print
      click_share_method(method: 'print')
      form_displayed?(method: 'print')
      click(SHARE_PRINT_BUTTON)
    end
  end

  class AdditionalInfo < BasePage
    THIRD_STEP = { css: '.MuiStep-root:nth-of-type(5) > button .MuiStepLabel-active' }.freeze
    NEXT_BTN = { css: 'button#next-btn:not(:disabled)' }.freeze

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

    REVIEW_SECTIONS = { css: '.referral-services-review > li' }.freeze
    SERVICE_TYPE = { css: '.referral-service-minimized__header-text' }.freeze
    DESCRIPTION = { css: '.detail-info__description-text' }.freeze
    RECIPIENTS = { css: '.service-type-section:nth-of-type(2) .detail-info__groups-list > li' }.freeze
    NETWORK = { css: '.service-type-section:nth-of-type(2) .detail-definition-list p' }.freeze
    FULL_NAME = { css: '.detail-definition-list__value' }.freeze

    SUBMIT_BTN = { css: '#submit-referral-btn' }.freeze

    def click_submit_button
      # element is behind an overlay so firefox cannot click it without using click_via_js
      click_via_js(SUBMIT_BTN)
    end

    def full_name
      text(FULL_NAME)
    end

    def network
      text(NETWORK).capitalize
    end

    def page_displayed?
      is_displayed?(FOURTH_STEP) &&
        is_displayed?(REFERRAL_FORM)
    end

    # returns an array containing one summary object for each referral/case being reviewed
    def summary_info
      info = []
      review_sections.each do |section|
        info << {
          service_type: service_type(section),
          recipients: recipients(section),
          description: description(section)
        }
      end
      info
    end

    private

    def description(section)
      section.find_elements(DESCRIPTION)[0].text
    end

    def recipients(section)
      section.find_elements(RECIPIENTS).collect { |ele| ele.text.sub('undefined', '').strip }.join('')
    end

    def review_sections
      find_elements(REVIEW_SECTIONS)
    end

    def service_type(section)
      service_type_str = section.find_elements(SERVICE_TYPE)[0].text
      # formatted - return only text after  "New referral: " or New Out of Network Case: "
      service_type_str.split(': ')[1].capitalize
    end
  end
end
