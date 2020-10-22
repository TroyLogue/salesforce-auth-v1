require_relative '../../../shared_components/base_page'

class ClosedAssistanceRequest < BasePage
  STATUS_DETAIL = { css: '.detail-status-text' }

  def go_to_closed_ar_with_id(ar_id:)
    get("/dashboard/assistance-requests/closed/#{ar_id}")
    wait_for_spinner
  end
  
  def status_detail_text
    text(STATUS_DETAIL)
  end
end
