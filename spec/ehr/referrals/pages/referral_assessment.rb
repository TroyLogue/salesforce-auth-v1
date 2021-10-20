# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ReferralAssessment < BasePage
  ASSESSMENT_TITLE = { css: '.px-6 > div > span' }
  BACK_BTN = { css: '#go-back-page-btn' }
  LOADING_SPINNER = { css: '.loader' }
  NEXT_BTN = { css: '#next-btn' }
  INPUT_FIELD = { css: 'input[type="text"]' }
  MAIN_CONTAINER = { css: '.bg-gray-light.border-DEFAULT.rounded.border-blue-border.mt-4' }

  def assessment_name_displayed?(name)
    text(ASSESSMENT_TITLE).include?(name)
  end

  def click_next
    click(NEXT_BTN)
  end

  def fill_out_and_create_referral(responses)
    responses.each_with_index do |response, i|
      input_fields[i].clear
      input_fields[i].send_keys response
    end
    create_referral
  end

  def page_displayed?(assessment_name: '')
    is_displayed?(MAIN_CONTAINER) &&
      is_displayed?(ASSESSMENT_TITLE) &&
      is_displayed?(BACK_BTN) &&
      is_displayed?(NEXT_BTN) &&
      assessment_name_displayed?(assessment_name) &&
      is_not_displayed?(LOADING_SPINNER)
  end

  private

  def input_fields
    find_elements(INPUT_FIELD)
  end

end
