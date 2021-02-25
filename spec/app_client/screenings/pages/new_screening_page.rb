# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class NewScreeningPage < BasePage
  NEW_SCREENING_CONTAINER = { css: '.screening-new-form' }
  SCREENING_STEPPER = { css: '.MuiStepper-root.MuiStepper-horizontal' }
  SCREENING_FORM = { css: '.ui-form-renderer' }
  SELECT_SCREENING_DROPDOWN = { css: '.screening-form-select .choices' }
  SELECT_NETWORK_DROPDOWN = { css: '.screening-network-form .choices' }
  SCREENING_CHOICE = { css: '.screening-form-select .choices__item' }
  NETWORK_CHOICE = { css: '.screening-network-form .choices__item'}
  SUBMIT_SCREENING_BTN = { xpath: '//div[@class="screening-new-form__actions text-right"]/button' }

  NO_NEED_FOR_RESOURCES_MESSAGE = "Thank You! It does not appear you need any community resources at this time. If things change, you may always call 2-1-1. 2-1-1 is a free and confidential service that helps Hoosiers across Indiana find the local resources they need. They are open 24 hours a day, 7 days a week."

  def page_displayed?
    wait_for_spinner
    is_displayed?(NEW_SCREENING_CONTAINER) &&
      is_displayed?(SCREENING_STEPPER)
  end

  # Specific to PRAPARE SCREENING
  PRAPARE_SCREENING_Q1 = { xpath: '//div[@class="ui-form-renderer-section"][1]/descendant::div[@class="choices"]'}
  PRAPARE_SCREENING_Q1_NO = { xpath: '//div[@class="ui-form-renderer-section"][1]/descendant::div[@class="choices__list"]/div[1]' }
  PRAPARE_SCREENING_Q1_YES = { xpath: '//div[@class="ui-form-renderer-section"][1]/descendant::div[@class="choices__list"]/div[2]' }
  PRAPARE_SCREENING_Q1_LABEL = { xpath:  '//div[@class="ui-form-renderer-section"][1]/descendant::div[@class="ui-form-renderer-question-display__label"]' }

  def refuse_prapare_screening
    click(PRAPARE_SCREENING_Q1)
    click(PRAPARE_SCREENING_Q1_NO)
  end

  def prapare_no_resources_needed_message_displayed?
    is_displayed?(PRAPARE_SCREENING_Q1_LABEL)
    raise "E2E Error: Expect #{NO_NEED_FOR_RESOURCES_MESSAGE}. Got #{text(PRAPARE_SCREENING_Q1_LABEL)}" unless NO_NEED_FOR_RESOURCES_MESSAGE == text(PRAPARE_SCREENING_Q1_LABEL)
    true
  end

  # specific to FOOD AND HOUSING SCREENING:
  SCREENING_NAME = "Food and Housing Screening"
  # answering yes will bring up referral needs
  RADIO_BTN = { css: '.ui-radio-field__item span' }

  def complete_screening_with_referral_needs
    select_screening(SCREENING_NAME)
    select_first_network if network_dropdown_displayed?
    click_element_by_text(RADIO_BTN, "Yes")
    submit_screening
  end

  def complete_screening_with_no_referral_needs
    select_screening(SCREENING_NAME)
    select_first_network if network_dropdown_displayed?
    click_element_by_text(RADIO_BTN, "No")
    submit_screening
  end

  def select_screening(screening_name)
    click(SELECT_SCREENING_DROPDOWN)
    click_element_by_text(SCREENING_CHOICE, screening_name)
    is_displayed?(SCREENING_FORM)
  end

  def select_first_network
    click(SELECT_NETWORK_DROPDOWN)
    click(NETWORK_CHOICE)
  end

  def submit_screening
    click(SUBMIT_SCREENING_BTN)
  end

  private
  def network_dropdown_displayed?
    check_displayed?(SELECT_NETWORK_DROPDOWN)
  end
end
