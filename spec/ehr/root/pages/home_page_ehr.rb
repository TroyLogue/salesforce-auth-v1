require_relative '../../../shared_components/base_page'

class HomePageEhr < BasePage
  ASSESSMENTS_BUTTON = { css: '#header3-btn' }
  CASES_BUTTON = { css: '#header2-btn' }
  CASES_TAB = { xpath: '//span[text()="Cases"]' }
  CREATE_REFERRAL_BUTTON = { xpath: '//span[text()="Create Referral"]' }
  NAVBAR = { css: '.bg-blue-dark.flex.fixed.w-screen.inset-x-0.top-0.h-16.items-center.pl-3.pr-3.z-30' }
  SCREENINGS_BUTTON = { css: '#header4-btn' }

  # just until EHR-525 is fixed:
  CASE_ROW = { xpath: '//table/tbody/tr[1]' }
  def default_view_displayed?
    # extending timeout for test cases that create multiple referrals i.e. uuqa_1771
    # and there is a delay in returning to the homepage
    is_displayed?(NAVBAR, 60) &&
      is_displayed?(CREATE_REFERRAL_BUTTON) &&
      is_displayed?(CASES_BUTTON) &&
      is_displayed?(ASSESSMENTS_BUTTON) &&
      is_displayed?(SCREENINGS_BUTTON)
  end

  def get_screening_detail(contact_id:, screening_id:)
    session_id = ehr_session_support_id
    get "/#{session_id}/contact/#{contact_id}/screenings/#{screening_id}"
  end

  def go_to_cases_tab
    click(CASES_TAB)
  end

  def go_to_create_referral
    click(CREATE_REFERRAL_BUTTON)
  end

  # only until EHR-525 is fixed
  def click_first_case
    is_displayed?(CASE_ROW) &&
      click(CASE_ROW)
  end

  def page_displayed?
    is_displayed?(NAVBAR)
  end

  # must be on the home page in patient context
  def contact_id
    current_url.split("#{ENV['WEB_URL']}/").last.split('/')[-1]
  end

  # When using EHR in a browser, the base URL is followed by an ID which is dynamically generated
  # toward managing different sessions in EHR desktop apps (Epic, Cerner).
  def ehr_session_support_id
    current_url.split("#{ENV['WEB_URL']}/").last.split('/').first
  end
end
