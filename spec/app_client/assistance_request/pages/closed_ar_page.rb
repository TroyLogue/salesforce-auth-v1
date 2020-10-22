require_relative '../../../shared_components/base_page'

class ClosedAssistanceRequest < BasePage
  STATUS_DETAIL = { css: '.detail-status-text' }
  
  def status_detail_text
    text(STATUS_DETAIL)
  end
end
