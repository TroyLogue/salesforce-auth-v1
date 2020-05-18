require_relative '../../../shared_components/base_page'

class Overview < BasePage

  OVERVIEW = { css: '.facesheet-overview' }
  INTERACTION_TAB = { css: '.interactions-interaction-tab' }
  PHONE_INTERACTION = { css: '#phone_call-label' }
  EMAIL_INTERACTION = { css: '#email-label' }
  INPERSON_INTERACTION = { css: '#meeting-label' }
  DURATION_DROPDOWN = { css: "div[aria-activedescendant='choices-interactionDuration-item-choice-1'] > .choices__inner" }
  DURATION_OPTIONS = { css: ".choices__list > div[data-value='%s']" }
  DURATIONS = { '< 15m' => '1', '15m' => '15', '30m' => '30', '45m' => '45',
                '1h' => '60', '1h 15m' => '75', '1h 30m' => '90', '1h 45m' => '105',
                '2h' => '120', '2h 15m' => '135', '2h 30m' => '150', '> 2h 30m' => '999999' }

  ATTACHED_TO_CASE = { css: '#case-label' }
  GENERAL_NOTE = { css: '#general-label' }
  TEXT_BOX = { css: '#interactionNote' }
  POST_NOTE = { css: '#log-interaction-post-note-btn' }
  SUCCESS_BANNER = { css: '.notification.success.velocity-animating' }
  CLIENT_TIMELINE_CREATED_ENTRY = { css: '.ui-base-card.ui-base-card--bordered.entry-card.create-interaction-entry' }
  CLIENT_TIMELINE_TYPE = { css: '#create-interaction-0-type' }
  CLIENT_TIMELINE_DURATION = { css: '#create-interaction-0-duration' }
  CLIENT_TIMELINE_NOTE = { css: '#create-interaction-0-note > span > span' }
  CLIENT_TIMELINE_GENERAL_ENTRY = { css: '.entry-context' }

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
    is_displayed?(SUCCESS_BANNER) #wait for banner to appear
  end

  def first_note_in_timeline
    #Wait for new entry to be displayed by waiting for banner to dissapear
    is_not_displayed?(SUCCESS_BANNER)
    #Return a note struct we can compare to
    { :type => text(CLIENT_TIMELINE_TYPE), :duration => text(CLIENT_TIMELINE_DURATION).gsub('Duration: ', ''), :content => text(CLIENT_TIMELINE_NOTE) }
  end

  def first_entry_in_timeline
    text(CLIENT_TIMELINE_GENERAL_ENTRY)
  end
end
