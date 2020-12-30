# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ReferralAssessment < BasePage
  ASSESSMENT_TITLE = { css: '.ui-expandable__header-content > div > span' }
  BACK_BTN = { css: '#assessments-back-btn' }
  CREATE_REFERRAL_BTN = { css: '#submit-assessments-btn' }
  EXPANDED_SECTION = { css: '.ui-expandable__container--expanded' }
  INPUT_FIELD = { css: 'input[type="text"]' }
  MAIN_CONTAINER = { css: '.referral-assessments__container' }

  def assessment_name_displayed?(name)
    text(ASSESSMENT_TITLE).include?(name)
  end

  def create_referral
    click(CREATE_REFERRAL_BTN)
  end

  def input_fields
    find_elements(INPUT_FIELD)
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
      is_displayed?(EXPANDED_SECTION) &&
      is_displayed?(BACK_BTN) &&
      is_displayed?(CREATE_REFERRAL_BTN) &&
      assessment_name_displayed?(assessment_name)
  end
end
