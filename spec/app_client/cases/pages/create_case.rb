require_relative '../../../shared_components/base_page'

class CreateCase < BasePage
  CREATE_CASE_FORM = { css: '.add-case-details' }.freeze
  PROGRAM_DROPDOWN = { css: '#program + .choices__list' }.freeze
  SERVICE_TYPE_DROPDOWN = { css: '#service-type + .choices__list' }.freeze
  PRIMARY_WORKER_DROPDOWN = { css: '#primary-worker + .choices__list' }.freeze
  CASE_INFORMATION_NEXT_BUTTON = { css: '#add-case-details-next-btn' }.freeze
  SUPPORTING_INFORMATION_NEXT_BUTTON = { css: '#next-btn' }.freeze
  SUPPORTING_INFORMATION_PAGE = { css: '.ui-form-field__label' }.freeze
  SUBMIT_CASE_BUTTON = { css: '#submit-case-btn' }.freeze

  def create_case_form_displayed?
    is_displayed?(CREATE_CASE_FORM)
  end

  def select_program(program_id)
    program = { css: "div[data-value='#{program_id}']" }
    click(PROGRAM_DROPDOWN)
    click(program)
  end

  def select_service_type(service_type_id)
    service_type = { css: "div[data-value='#{service_type_id}']" }
    click(SERVICE_TYPE_DROPDOWN)
    click(service_type)
  end

  def select_primary_worker(primary_worker_id)
    primary_worker = { css: "div[data-value='#{primary_worker_id}']" }
    click(PRIMARY_WORKER_DROPDOWN)
    click(primary_worker)
  end

  def create_new_case(program_id:, service_type_id:, primary_worker_id:)
    select_program(program_id)
    select_service_type(service_type_id)
    select_primary_worker(primary_worker_id)
    click(CASE_INFORMATION_NEXT_BUTTON)
    click(SUPPORTING_INFORMATION_NEXT_BUTTON) if is_displayed?(SUPPORTING_INFORMATION_PAGE)
    click(SUBMIT_CASE_BUTTON)
  end
end
