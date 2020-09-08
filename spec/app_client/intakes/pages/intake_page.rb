require_relative '../../../shared_components/base_page'

class Intake < BasePage
  INTAKE_NAVIGATION = { css: '.intake-container__navigation' }
  INTAKE_FORM = { css: '.intake-container__content' }

  FIRSTNAME_INPUT = { css: '#first-name' }
  LASTNAME_INPUT = { css: '#last-name' }
  DOB_INPUT = { css: '#date-of-birth' }
  INTAKE_NOTES = { css: '#general-notes' }
  SUBMIT_BTN = { css: '#form-footer-submit-btn' }

  


  #Intake Navigation
  #Program Services
  BASIC_INFORMATION = {css: '#basic-information-nav-item'}
  CONTACT_INFORMATION = {id: 'contact-information-nav-item'}
  LOCATION_INFORMATION = {id: 'location-information-nav-item'}
  HOUSEHOLD_INFORMATION = {id: 'household-information-nav-item'}
  OTHER_INFORMATION = {id: 'other-information-nav-item'}
  MILITARY_INFORMATION = {id: 'military-information-nav-item'}
  GENERAL_NOTES = {id: 'general-notes-nav-item'}
  SERVICE_INFORMATION = {link_text: 'Service Information'}
  CARE_COORDINATOR = {id: 'care-coordinator-nav-item'}

  #Other Information fields
  MARITAL_STATUS = {css: '#marital-status + .choices__list'}
  GENDER = {css: '#gender + .choices__list'}
  RACE = {css: '#race + .choices__list'}
  ETHNICITY = {css: '#ethnicity + .choices__list'}
  CITIZENSHIP = {css: '#citizenship + .choices__list'}
  SSN_INPUT = {id: 'ssn'}

  #dropdown menu first options
  MARITAL_STATUS_OPTION = {id: 'choices-marital-status-item-choice-1'}
  GENDER_OPTION = {id: 'choices-gender-item-choice-2'}
  RACE_OPTION = {id: 'choices-race-item-choice-1'}
  ETHNICITY_OPTION = {id: 'choices-ethnicity-item-choice-1'}
  CITIZENSHIP_OPTION = {id: 'choices-citizenship-item-choice-3'}


  #general notes
  GENERAL_NOTES = {css: '.ui-gradient #general-notes'}

  #checkbox
  NEEDS_ACTION_CHECKBOX = {css: '#needs-action-checkbox-field + label'}

  

  
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

  def select_other_information
    click( OTHER_INFORMATION)
  end

  def select_marital_status
    click(MARITAL_STATUS)
    click(MARITAL_STATUS_OPTION)
    end

  def select_gender
    click(GENDER)
    click(GENDER_OPTION)
      end

  def select_race
    click(RACE)
    click(RACE_OPTION)
   end

  def select_ethnicity
    click(ETHNICITY)
    click(ETHNICITY_OPTION)
   end
          
          
    def select_citzenship
      click(CITIZENSHIP)
      click(CITIZENSHIP_OPTION)
      end

     def input_ssn
      enter("123456789",SSN_INPUT)
       end

     def add_note
      enter("The user should enter a Medicaid ID and State", GENERAL_NOTES) 
      end

     def check_checkbox
      click(NEEDS_ACTION_CHECKBOX)          
       end
end
