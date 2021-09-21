# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class CaseDetailPage < BasePage
  HEADER = { css: '.casedetails .details-header' }.freeze

  #TODO update selector for CASE_INFO section
  CASE_INFO = { css: '.casedetails' }.freeze
  CASE_INFO_PRIMARY_WORKER = { css: '#primary-worker-input div>span' }.freeze
  NO_CHOICES_ITEMS = { css: '.has-no-choices' }.freeze
  PRIMARY_WORKER_EDIT_BUTTON = { id: 'primary-worker-input-edit-btn' }.freeze
  PRIMARY_WORKER_DROPDOWN = { css: '#primary-worker-input + .choices__list' }.freeze
  PRIMARY_WORKER_OPTION = { css: '#primary-worker-input .choices__list > .choices__item' }.freeze
  PRIMARY_WORKER_SAVE_BUTTON = { id: 'primary-worker-input-save-btn' }.freeze

  CARE_TEAM = { css: '.case-info-expandable--care-team' }.freeze
  CARE_TEAM_CONTENT = { css: '.case-info-expandable--care-team .row' }.freeze
  CARE_TEAM_PRIMARY_WORKER = { css: '.case-info-expandable--care-team .row > div:nth-child(4) > span' }.freeze

  DESCRIPTION = { css: '.top-desc' }.freeze
  ADD_NOTE_BTN = { css: '#add-note-btn' }.freeze
  NOTE_TEXTAREA = { id: 'ui-note-form-note-field' }.freeze
  TIMELINE = { css: '.timeline' }.freeze

  def page_displayed?
    is_displayed?(HEADER) &&
      is_displayed?(CASE_INFO) &&
#      is_displayed?(CARE_TEAM) &&
      is_displayed?(DESCRIPTION) &&
      is_displayed?(ADD_NOTE_BTN) &&
      is_displayed?(TIMELINE)
  end

  def case_info_primary_worker
    text(CASE_INFO_PRIMARY_WORKER)
  end

  def care_team_content
    text(CARE_TEAM_CONTENT)
  end

  def care_team_primary_worker
    text(CARE_TEAM_PRIMARY_WORKER)
  end

  def description_text
    text(DESCRIPTION)
  end

  def primary_worker_edit_button_displayed?
    is_displayed?(PRIMARY_WORKER_EDIT_BUTTON)
  end

  def update_primary_worker_to_random_option
    open_primary_worker_dropdown

    random_option = find_elements(CASE_INFO_CHOICES_ITEM).sample
    worker_name = random_option.text.strip
    random_option.click
    click(PRIMARY_WORKER_SAVE_BUTTON)

    worker_name
  end

  private

  def open_primary_worker_dropdown
    click(PRIMARY_WORKER_EDIT_BUTTON)
    click(PRIMARY_WORKER_DROPDOWN)
    is_not_displayed?(NO_CHOICES_ITEMS)
  end
end
