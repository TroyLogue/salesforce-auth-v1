# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class CaseReview < BasePage
  EDIT_BUTTON = { css: '.detail-review__footer #edit-case-btn' }.freeze
  NOTES = {  css: '.detail-review__row:nth-of-type(4) .detail-review__text--short' }.freeze
  PRIMARY_WORKER = { css: '.detail-review__row:nth-of-type(2) .col-xs-6:nth-of-type(2) .detail-review__text--short' }.freeze
  REFERRED_TO = {  css: '.detail-review__row:nth-of-type(3) .detail-review__text--short' }.freeze
  REVIEW_FORM = { css: '.case-review' }.freeze
  SERVICE_TYPE = { css: '.detail-review__row:nth-of-type(1) .detail-review__text--short' }.freeze
  STEPPER = { css: '.MuiStepper-root.MuiStepper-horizontal' }.freeze
  SUBMIT_BUTTON = { css: '#submit-case-btn' }.freeze

  def page_displayed?
    is_displayed?(STEPPER) &&
      is_displayed?(REVIEW_FORM) &&
      is_displayed?(EDIT_BUTTON) &&
      is_displayed?(SUBMIT_BUTTON)
  end

  def click_submit_button
    click(SUBMIT_BUTTON)
    wait_for_spinner
  end

  def notes
    text(NOTES)
  end

  def primary_worker
    text(PRIMARY_WORKER)
  end

  def referred_to
    text(REFERRED_TO)
  end

  def service_type
    text(SERVICE_TYPE)
  end
end
