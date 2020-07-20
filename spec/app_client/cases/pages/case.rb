require_relative '../../../../lib/file_helper'

class Case < BasePage
  CASE_VIEW = { css: '.dashboard-content .case-detail-view'}
  CASE_STATUS = { css: '.detail-status-text' }

  OPEN_STATUS = 'OPEN'

  def page_displayed?
    is_displayed?(CASE_VIEW)
  end

  def status
    text(CASE_STATUS)
  end
end
