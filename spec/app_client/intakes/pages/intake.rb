require_relative '../../../shared_components/base_page'

class Intake < BasePage
  INTAKE_NAVIGATION = { css: '.intake-container__navigation' }
  INTAKE_FORM = { css: '.intake-container__content' }

  FIRSTNAME_INPUT = { css: '#first-name' }
  LASTNAME_INPUT = { css: '#last-name' }
  DOB_INPUT = { css: '#date-of-birth' }
  INTAKE_NOTES = { css: '#general-notes' }
  SUBMIT_BTN = { css: '#form-footer-submit-btn' }

  def page_displayed?
    is_displayed?(INTAKE_NAVIGATION) &&
    is_displayed?(INTAKE_FORM)
  end

  # for now we are only looking for firstname, lastname, dob
  def is_info_prefilled?(**params)
    if params.key?(:fname) && value(FIRSTNAME_INPUT) != params[:fname]
      print "First Name value saved '#{params[:fname]}' do not equal value displayed '#{value(FIRSTNAME_INPUT)}'"
      return false
    end
    if params.key?(:lname) && value(LASTNAME_INPUT) != params[:lname]
      print "Last Name value saved '#{params[:fname]}' do not equal value displayed '#{value(LASTNAME_INPUT)}'"
      return false
    end
    if params.key?(:dob) && value(DOB_INPUT) != params[:dob]
      print "Dob value saved '#{params[:dob]}' do not equal value displayed '#{value(DOB_INPUT)}'"
      return false
    end
    true
  end

  def save_intake
    click(SUBMIT_BTN)
    wait_for_spinner
  end
end
