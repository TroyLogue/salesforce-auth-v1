# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class NewScreeningPage < BasePage
  NEW_SCREENING_CONTAINER = { css: '.screenings-new' }
  SCREENING_STEPPER = { css: '.MuiStepper-root.MuiStepper-horizontal' }
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
end