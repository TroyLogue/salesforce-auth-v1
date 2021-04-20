require_relative '../../../shared_components/base_page'

class AddClient < BasePage
  ADD_CONTACT_FORM = { css: '.add-contact-information-form' }
  ADD_CONTACT_FROM_REFERRAL = { css: '.add-contact-from-referral' }
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

  SAVE_BTN = { css: '#save-client-btn' }
  GO_BACK_BTN = { css: '#go-back-btn' }

  def page_displayed?
    is_displayed?(ADD_CONTACT_FORM)
  end

  def is_info_prefilled?(**params)
    if params.key?(:fname) && value(FIRSTNAME_INPUT).downcase != params[:fname].downcase
      print "First Name value saved '#{params[:fname]}' do not equal value displayed '#{value(FIRSTNAME_INPUT)}'"
      return false
    end
    if params.key?(:lname) && value(LASTNAME_INPUT).downcase != params[:lname].downcase
      print "Last Name value saved '#{params[:lname]}' do not equal value displayed '#{value(LASTNAME_INPUT)}'"
      return false
    end
    if params.key?(:dob) && value(DOB_INPUT) != params[:dob]
      print "Dob value saved '#{params[:dob]}' do not equal value displayed '#{value(DOB_INPUT)}'"
      return false
    end
    if params.key?(:addresses) && single_lined_address != params[:addresses]
      print "Address value saved '#{params[:addresses]}' do not equal value displayed '#{single_lined_address}'"
      return false
    end
    if params.key?(:phone) && value(PHONE_INPUT) != params[:phone]
      print "Phone value saved '#{params[:phone]}' do not equal value displayed '#{value(PHONE_INPUT)}'"
      return false
    end
    if params.key?(:military_affiliation) && value(MILITARY_AFFILIATION_INPUT) != params[:military_affiliation]
      print "Phone value saved '#{params[:military_affiliation]}' do not equal value displayed '#{value(MILITARY_AFFILIATION_INPUT)}'"
      return false
    end
    true
  end

  # If a param is not set, it will not be typed
  def add_client_info(**params)
    enter(params[:fname], FIRSTNAME_INPUT) if params.key?(:fname)
    enter(params[:lname], LASTNAME_INPUT) if params.key?(:lname)
    enter(params[:dob], DOB_INPUT) if params.key?(:dob)
    enter(params[:ss], SS_INPUT) if params.key?(:ss)
    enter(params[:phone], PHONE_INPUT) if params.key?(:phone)
    enter(params[:email], EMAIL_INPUT) if params.key?(:email)
    enter(params[:address_line_1], ADDRESS_LINE1_INPUT) if params.key?(:address_line_1)
    enter(params[:address_line_2], ADDRESS_LINE2_INPUT) if params.ket?(:address_line_2)
    enter(params[:address_city], ADDRESS_CITY_INPUT) if params.key?(:address_city)
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

  def save_client
    click(SAVE_BTN)
    wait_for_spinner
  end
end
