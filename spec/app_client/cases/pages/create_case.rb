require_relative '../../../shared_components/base_page'

class CreateCase < BasePage
  CREATE_CASE_FORM = { css: '.add-case-details' }.freeze
  PROGRAM_DROPDOWN = { css: '#program + .choices__list' }.freeze
  COLUMBIA_PROGRAM = { css: '#choices-program-item-choice-2' }.freeze
  SERVICE_TYPE_DROPDOWN = { css: '#service-type + .choices__list' }.freeze
  BENEFITS_ELIGIBILITY_SCREENING = { css: '#choices-service-type-item-choice-2' }.freeze
  PRIMARY_WORKER_DROPDOWN = { css: '#primary-worker + .choices__list' }.freeze
  PRIMARY_WORKER_COLUMBIA_IVY = { css: '#choices-primary-worker-item-choice-2' }.freeze
  CASE_INFORMATION_NEXT_BUTTON = { css: '#add-case-details-next-btn' }.freeze
  SUPPORTING_INFORMATION_NEXT_BUTTON = { css: '#next-btn' }.freeze
  SUPPORTING_INFORMATION_PAGE = { css: '.ui-form-field__label' }.freeze
  SUBMIT_CASE_BUTTON = { css: '#submit-case-btn' }.freeze

  def create_case_form_displayed?
    is_displayed?(CREATE_CASE_FORM)
  end

  def select_columbia_program
    click(PROGRAM_DROPDOWN)
    click(COLUMBIA_PROGRAM)
  end

  def select_benefits_eligibility_screening_service_type
    click(SERVICE_TYPE_DROPDOWN)
    click(BENEFITS_ELIGIBILITY_SCREENING)
  end

  def select_columbia_ivy_as_primary_worker
    click(PRIMARY_WORKER_DROPDOWN)
    click(PRIMARY_WORKER_COLUMBIA_IVY)
  end

  def create_new_case_for_columbia_program
    select_columbia_program
    select_benefits_eligibility_screening_service_type
    select_columbia_ivy_as_primary_worker
    click(CASE_INFORMATION_NEXT_BUTTON)
    is_displayed?(SUPPORTING_INFORMATION_PAGE)
    click(SUPPORTING_INFORMATION_NEXT_BUTTON)
    click(SUBMIT_CASE_BUTTON)
  end
end
