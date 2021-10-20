require_relative '../../../shared_components/base_page'

class HomePageEhr < BasePage
  ASSESSMENTS_BUTTON = { css: '#header3-btn' }
  CASES_BUTTON = { css: '#header2-btn' }
  CASES_TAB = { xpath: '//span[text()="Cases"]' }
  CREATE_REFERRAL_BUTTON = { xpath: '//span[text()="Create Referral"]' }
  NAVBAR = { css: '.bg-blue-dark.flex.fixed.w-screen.inset-x-0.top-0.h-16.items-center.pl-3.pr-3.z-30' }
  SCREENINGS_BUTTON = { css: '#header4-btn' }

  # Case Created Popup
  CLOSE_POPUP_BTN = { css: 'button[data-qa=close-btn]' }
  CASES_CREATED_HEADER = { xpath: '//h1[text()="Cases Created"]' }
  PROVIDER_CHECKBOX = { css: '.consent-wrapper input[type=checkbox]' }
  SHARE_FORM = { id: 'network-browse-share-form' }
  SHARE_CANCEL_BTN = { id: 'share-cancel-button' }
  SHARE_SEND_BTN = { id: 'share-send-button' }


  def case_created_popup_displayed?
    is_displayed?(CASES_CREATED_HEADER) &&
      is_displayed?(PROVIDER_CHECKBOX) &&
      is_displayed?(SHARE_FORM) &&
      is_displayed?(SHARE_CANCEL_BTN) &&
      is_displayed?(SHARE_SEND_BTN) &&
      is_displayed?(CLOSE_POPUP_BTN)
  end

  def close_case_created_popup
    click(CLOSE_POPUP_BTN)
  end

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
    get "/#{session_id}/2/patient/#{contact_id}/screenings/#{screening_id}"
  end

  def go_to_assessments_tab
    click(ASSESSMENTS_BUTTON)
  end

  def go_to_cases_tab
    click(CASES_TAB)
  end

  def go_to_screenings_tab
    click(SCREENINGS_BUTTON)
  end

  def go_to_create_referral
    click(CREATE_REFERRAL_BUTTON)
  end

  def page_displayed?
    is_displayed?(NAVBAR)
  end

  # must be on the home page in patient context
  def contact_id
    current_url.split("#{ENV['WEB_URL']}/").last.split('/')[-2]
  end

  # When using EHR in a browser, the base URL is followed by an ID which is dynamically generated
  # toward managing different sessions in EHR desktop apps (Epic, Cerner).
  def ehr_session_support_id
    current_url.split("#{ENV['WEB_URL']}/").last.split('/').first
  end
end
