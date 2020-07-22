require_relative '../../../shared_components/base_page'

class AddClient < BasePage
  ADD_CONTACT_FORM = { css: '.add-contact-information-form' }
  FIRSTNAME_INPUT = { css: '#first-name' }
  LASTNAME_INPUT = { css: '#last-name' }
  DOB_INPUT = { css: '#date-of-birth' }
  SS_INPUT = { css: '#social-security-number' }

  EMAIL_INPUT = { css: '#email-0' }
  PHONE_INPUT = { css: '#phone-0-number' }

  ADDRESS_LINE1_INPUT = { css: '#address-0-line1' }
  ADDRESS_LINE2_INPUT = { css: '#address-0-line2' }
  ADDRESS_CITY_INPUT = { css: '#address-0-city' }
  ADDRESS_STATE_INPUT = { css: '#address-0-state + div > div:not(button) ' }
  ADDRESS_ZIPCODE_INPUT = { css: '#address-0-postal-code' }

  INSURANCE_MBID_INPUT = { css: '#insurance-id-0' }
  INSURANCE_MID_INPUT = { css: '#insurance-id-1' }
  INSURANCE_STATE_INPUT = { css: '#insurance-state-1 + div > div' }

  MILITARY_AFFILIATION_INPUT = { css: '#affiliation > option' }

  def page_displayed?
    is_displayed?(ADD_CONTACT_FORM)
  end

  def is_info_prefilled?(**params)
    value(FIRSTNAME_INPUT) == params[:fname] &&
    value(LASTNAME_INPUT) == params[:lname] &&
    value(DOB_INPUT) == params[:dob] &&
    single_lined_address == params[:addresses] &&
    value(PHONE_INPUT) == params[:phone] &&
    value(MILITARY_AFFILIATION_INPUT) == params[:military_affiliation]
  end

  # If a param is not set, it will not be typed
  def add_client_info(**params)
    enter(params[:fname], FIRSTNAME_INPUT) if params.key?(:fname)
    enter(params[:lname], LASTNAME_INPUT) if params.key?(:lname)
    enter(params[:dob], DOB_INPUT) if params.key?(:dob)
    enter(params[:ss], SS_INPUT) if params.key?(:ss)
  end

  def single_lined_address
    value(ADDRESS_LINE1_INPUT) + ' ' +
    value(ADDRESS_LINE2_INPUT) + ' ' +
    text(ADDRESS_STATE_INPUT).sub!('Remove item','').strip! + ' ' +
    value(ADDRESS_ZIPCODE_INPUT)
  end

  def single_lined_insurance
    value(INSURANCE_MBID_INPUT) + ' ' +
    value(INSURANCE_MID_INPUT) + ' ' +
    text(INSURANCE_STATE_INPUT).sub!('Remove item','').strip!
  end
end
