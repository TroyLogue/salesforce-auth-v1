# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class DashboardNav < BasePage
  DASHBOARD_NAV = { class: 'dashboard-nav' }.freeze

  # Incoming Referrals
  NEW_REFERRALS = { id: 'dashboard-new-referrals' }.freeze
  IN_REVIEW_REFERRALS = { id: 'dashboard-referrals-in-review' }.freeze
  RECALLED_REFERRALS = { id: 'dashboard-referrals-recalled ' }.freeze
  REJECTED_REFERRALS = { id: 'dashboard-referrals-rejected' }.freeze
  PROVIDER_TO_PROVIDER = { id: 'dashboard-referrals-provider-to-provider' }.freeze
  SCREENINGS_ALL = { id: 'dashboard-screenings-all' }.freeze

  def go_to_new_referrals
    click(NEW_REFERRALS)
  end

  def go_to_in_review_referrals
    click(IN_REVIEW_REFERRALS)
  end

  def go_to_recalled_referrals
    click(RECALLED_REFERRALS)
  end

  def go_to_rejected_referrals
    click(REJECTED_REFERRALS)
  end

  def go_to_provider_to_provider_referrals
    click(PROVIDER_TO_PROVIDER)
  end

  def go_to_screening(screening_id:)
    get("/dashboard/screenings/all/#{screening_id}")
  end

  def go_to_screenings
    click(SCREENINGS_ALL)
  end

  def screenings_displayed?
    is_displayed?(SCREENINGS_ALL)
  end
end
