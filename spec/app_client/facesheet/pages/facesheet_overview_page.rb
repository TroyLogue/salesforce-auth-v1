# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

module Timeline
  TIMELINE_INTERACTION_TYPE = { css: '#create-interaction-0-type' }.freeze
  TIMELINE_INTERACTION_DURATION = { css: '#create-interaction-0-duration' }.freeze
  TIMELINE_INTERACTION_NOTE = { css: '#create-interaction-0-note > span > span' }.freeze
  TIMELINE_GENERAL_ENTRY = { css: '.entry-context' }.freeze
  TIMELINE_ENTRIES = { css: '.entry-card' }.freeze
  LOADING_ENTRIES = { css: '.loading-entries__content' }.freeze
  SUCCESS_BANNER = { css: '.notification.success.velocity-animating' }.freeze

  def first_interaction_note_in_timeline
    # Wait for new entry to be created by waiting for banner to dissapear
    is_not_displayed?(SUCCESS_BANNER)

    # verify the timeline is updated with the new note
    get_timeline_event(event_type: TIMELINE_INTERACTION_TYPE)

    # Return a note struct we can compare to
    { type: text(TIMELINE_INTERACTION_TYPE), duration: text(TIMELINE_INTERACTION_DURATION).gsub('Duration: ', ''),
      content: text(TIMELINE_INTERACTION_NOTE) }
  end

  private

  # uniteus-timeline is asyncronous; we will need to use retries to avoid flaky tests
  # until Core Consolidation is complete
  def get_timeline_event(event_type:, retries: 5)
    return unless retries > 0

    refresh
    find(event_type)
  rescue RuntimeError
    get_timeline_event(event_type: event_type, retries: retries - 1)
  end
end

class FacesheetOverview < BasePage
  include Timeline

  OVERVIEW = { css: '.facesheet-overview' }.freeze

  def page_displayed?
    is_displayed?(OVERVIEW) &&
      wait_for_spinner
  end
end
