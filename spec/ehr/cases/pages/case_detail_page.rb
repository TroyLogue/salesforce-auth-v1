# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class CaseDetailPage < BasePage
  HEADER = { css: '.casedetails .details-header' }.freeze

  CASE_INFO = { css: '.casedetails' }.freeze
  CARE_COORDINATOR_EDIT_BTN = { css: '#care-coordinator a' }.freeze
  CARE_COORDINATOR = { css: '#care-coordinator div+span' }.freeze
  PRIMARY_WORKER = { css: '#primary-worker-input div+span' }.freeze
  PRIMARY_WORKER_EDIT_BUTTON = { id: 'primary-worker-input-edit-btn' }.freeze
  PRIMARY_WORKER_DROPDOWN = { css: '#primary-worker-input .choices' }.freeze
  PRIMARY_WORKER_OPTION = { css: '#primary-worker-input .choices__list > .choices__item' }.freeze
  PRIMARY_WORKER_SAVE_BUTTON = { id: 'primary-worker-input-save-btn' }.freeze

  DESCRIPTION = { css: '.top-desc' }.freeze
  ADD_NOTE_BTN = { css: '#add-note-btn' }.freeze
  NOTE_TEXTAREA = { id: 'ui-note-form-note-field' }.freeze
  TIMELINE = { css: '.timeline' }.freeze

  def page_displayed?
    is_displayed?(HEADER) &&
      is_displayed?(CASE_INFO) &&
#      is_displayed?(CARE_TEAM) &&
      is_displayed?(DESCRIPTION) &&
      is_displayed?(ADD_NOTE_BTN)
    #leave out timeline for consolidation for now
#      is_displayed?(TIMELINE)
  end

  def primary_worker
    text(PRIMARY_WORKER)
  end

  def description_text
    text(DESCRIPTION)
  end

  def primary_worker_edit_button_displayed?
    is_displayed?(PRIMARY_WORKER_EDIT_BUTTON)
  end

  def update_primary_worker_to_random_option
    open_primary_worker_dropdown

    random_option = find_elements(PRIMARY_WORKER_OPTION).sample
    worker_name = random_option.text.strip
    random_option.click
    click(PRIMARY_WORKER_SAVE_BUTTON)

    worker_name
  end

  private

  def open_primary_worker_dropdown
    click(PRIMARY_WORKER_EDIT_BUTTON)
    click(PRIMARY_WORKER_DROPDOWN)
  end
end
