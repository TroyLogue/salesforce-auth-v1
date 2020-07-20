require_relative '../../../../lib/file_helper'

class ReferralTable < BasePage
  REFERRALS_TABLE = { css: '.dashboard-inner-content .dynamic-table' }

  def page_displayed?
    wait_for_spinner
    is_displayed?(REFERRALS_TABLE)
  end
end
