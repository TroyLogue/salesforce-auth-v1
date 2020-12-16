# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class FacesheetOverviewPage < BasePage
  OVERVIEW = { css: '.facesheet-overview' }.freeze
  INTERACTION_TAB = { css: '.interactions-interaction-tab' }.freeze
  PHONE_INTERACTION = { css: '#phone_call-label' }.freeze
  EMAIL_INTERACTION = { css: '#email-label' }.freeze
  INPERSON_INTERACTION = { css: '#meeting-label' }.freeze
  DURATION_DROPDOWN = { css: "div[aria-activedescendant='choices-interactionDuration-item-choice-1'] > .choices__inner" }.freeze
  DURATION_OPTIONS = { css: ".choices__list > div[data-value='%s']" }.freeze
  DURATIONS = { '< 15m' => '1', '15m' => '15', '30m' => '30', '45m' => '45',
                '1h' => '60', '1h 15m' => '75', '1h 30m' => '90', '1h 45m' => '105',
                '2h' => '120', '2h 15m' => '135', '2h 30m' => '150', '> 2h 30m' => '999999' }.freeze

  ATTACHED_TO_CASE = { css: '#case-label' }.freeze
  GENERAL_NOTE = { css: '#general-label' }.freeze
  TEXT_BOX = { css: '#interactionNote' }.freeze
  POST_NOTE = { css: '#log-interaction-post-note-btn' }.freeze
  SUCCESS_BANNER = { css: '.notification.success.velocity-animating' }.freeze
  TIMELINE_INTERACTION_ENTRY = { css: '.create-interaction-entry' }.freeze
  TIMELINE_INTERACTION_TYPE = { css: '#create-interaction-0-type' }.freeze
  TIMELINE_INTERACTION_DURATION = { css: '#create-interaction-0-duration' }.freeze
  TIMELINE_INTERACTION_NOTE = { css: '#create-interaction-0-note > span > span' }.freeze
  TIMELINE_GENERAL_ENTRY = { css: '.entry-context' }.freeze

  def page_displayed?
    is_displayed?(OVERVIEW)
    wait_for_spinner
  end

  def add_interaction(note)
    case note[:type]
    when 'Phone Call'
      click(PHONE_INTERACTION)
      click(DURATION_DROPDOWN)
      click(DURATION_OPTIONS.transform_values { |v| v % DURATIONS[note[:duration]] })
    when 'Email'
      click(EMAIL_INTERACTION)
    when 'Meeting'
      click(INPERSON_INTERACTION)
      click(DURATION_DROPDOWN)
      click(DURATION_OPTIONS.transform_values { |v| v % DURATIONS[note[:duration]] })
    end

    enter(note[:content], TEXT_BOX)
    click(POST_NOTE)
    is_displayed?(SUCCESS_BANNER) # wait for banner to appear
  end

  def first_interaction_note_in_timeline
    # Wait for new entry to be displayed by waiting for banner to dissapear and an interaction entry in the timeline
    # If unstable, may need to add a page-refresh to ensure the timeline displays the latest entries
    is_not_displayed?(SUCCESS_BANNER)
    is_displayed?(TIMELINE_INTERACTION_ENTRY)
    # Return a note struct we can compare to
    { type: text(TIMELINE_INTERACTION_TYPE), duration: text(TIMELINE_INTERACTION_DURATION).gsub('Duration: ', ''), content: text(TIMELINE_INTERACTION_NOTE) }
  end

  def first_entry_in_timeline
    text(TIMELINE_GENERAL_ENTRY)
  end
end
