require_relative '../../../shared_components/base_page'

class AddClient < BasePage
  ADD_CONTACT_FORM = { css: '.add-contact-information' }
  FIRSTNAME_INPUT = { css: '#first-name' }
  LASTNAME_INPUT = { css: '#last-name' }
  DOB_INPUT = { css: '#date-of-birth' }
  SS_INPUT = { css: '#social-security-number' }

  def page_displayed?
    is_displayed?(ADD_CONTACT_FORM)
  end

  # If a param is not set, it will not be typed
  def add_client_info(**params)
    enter(params[:fname], FIRSTNAME_INPUT) if params.key?(:fname)
    enter(params[:lname], LASTNAME_INPUT) if params.key?(:lname)
    enter(params[:dob], DOB_INPUT) if params.key?(:dob)
    enter(params[:ss], SS_INPUT) if params.key?(:ss)
  end
end
