require_relative '../../root/pages/notifications'

module Settings
  class ProgramTable < BasePage
    PROGRAMS_TABLE = { css: '.programs' }
    PROGRAMS_TABLE_LOAD = { xpath: 'h2[text()="Loading Programs..."]' }
    NEW_PROGRAM_BTN = { css: '.ui-button.ui-button--primary' }
    PROGRAMS_LIST = { css: '.ui-base-card-header__title' }
    PROGRAM_EDIT = { xpath: './/h2[text()="%s"]/following-sibling::div/div/button' }

    def page_displayed?
      is_not_displayed?(PROGRAMS_TABLE_LOAD)
      is_displayed?(PROGRAMS_TABLE)
    end

    def get_list_of_programs
      names = find_elements(PROGRAMS_LIST)
      names_array = names.collect(&:text)
    end

    def edit_program(name:)
      click(PROGRAM_EDIT.transform_values { |v| v % name })
    end

    def get_program_description(name:)
      text(PROGRAM_DESCRIPTION.transform_values { |v| v % name })
    end

    def go_to_new_program_form
      click(NEW_PROGRAM_BTN)
    end

    def are_changes_saved?
      is_displayed?(Notifications::SUCCESS_BANNER)
    end
  end

  class ProgramForm < BasePage
    PROGRAM_HEADER = { css: '.ui-base-card-header__title' }
    INPUT_PROGRAM_NAME = { css: '#program-name' }
    CHECKBOX_PROGRAM_REFERRAL = { css: 'label[for="program-referral-toggle"]' }
    TEXT_PROGRAM_REFERRAL_CONTENT = { css: '.referral-content' }
    INPUT_PROGRAM_DESCRIPTION = { css: '#program-description' }
    INPUT_PAYMENT_OPTIONS = { css: '#program-payment-options' }
    INPUT_ACCESSIBILITY_OPTIONS = { css: '#program-accessibility-options' }
    INPUT_TRANSPORTATION = { css: '#program-transportation-options' }
    INPUT_SERVICE_DELIVERY = { css: 'div[aria-activedescendant^="choices-program-service-delivery-options-item-choice"]' }
    INPUT_POPULATION_RESTRICTION = { css: 'div[aria-activedescendant^="choices-program-populations-restricted-to-item-choice"]' }
    INPUT_POPULATION_CATERED = { css: 'div[aria-activedescendant^="choices-program-populations-catered-to-item-choice"]' }
    INPUT_STATE = { css: 'div[aria-activedescendant^="choices-program-us-states-item-choice"]' }
    INPUT_COUNTY = { css: 'label[for="program-us-counties"]' }
    INPUT_CITIES = { css: 'label[for="program-us-cities"]' }
    INPUT_LANGUAGE = { css: 'div[aria-activedescendant^="choices-program-languages-item-choice"]' }
    INPUT_SERVICE_TYPES = { css: '.service-types-checkboxes' }
    INPUT_PROGRAM_ELIGIBILITY = { css: '#program-eligibility' }
    UPDATE_BTN = { css: '#new-program-submit-btn' }

    def page_displayed?
      is_displayed?(INPUT_PROGRAM_NAME) && is_displayed?(CHECKBOX_PROGRAM_REFERRAL) && is_displayed?(INPUT_PROGRAM_DESCRIPTION) &&
      is_displayed?(INPUT_PAYMENT_OPTIONS) && is_displayed?(INPUT_ACCESSIBILITY_OPTIONS) && is_displayed?(INPUT_TRANSPORTATION) &&
      is_displayed?(INPUT_SERVICE_DELIVERY) && is_displayed?(INPUT_POPULATION_RESTRICTION) && is_displayed?(INPUT_POPULATION_CATERED) &&
      is_displayed?(INPUT_STATE) && is_displayed?(INPUT_COUNTY) && is_displayed?(INPUT_CITIES) && is_displayed?(INPUT_LANGUAGE) &&
      is_displayed?(INPUT_SERVICE_TYPES) && is_displayed?(INPUT_PROGRAM_ELIGIBILITY)
    end

    def get_program_title
      text(PROGRAM_HEADER)
    end

    def save_changes
      click(UPDATE_BTN)
      is_not_displayed?(UPDATE_BTN, 5)
    end

    def get_program_referral_dialog
      text(TEXT_PROGRAM_REFERRAL_CONTENT)
    end

    def toggle_program_referral
      click(CHECKBOX_PROGRAM_REFERRAL)
    end

    def is_program_referral_on?
      is_selected?(CHECKBOX_PROGRAM_REFERRAL)
    end
  end
end
