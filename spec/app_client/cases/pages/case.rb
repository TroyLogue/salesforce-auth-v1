# frozen_string_literal: true

class Case < BasePage
  CASE_VIEW = { css: '.dashboard-content .case-detail-view'}.freeze
  CASE_STATUS = { css: '.detail-status-text' }.freeze
  NOTES = { css: '.detail-info__summary p > span' }.freeze
  OPEN_STATUS = 'OPEN'
  PRIMARY_WORKER = { css: '#basic-table-primary-worker-value' }.freeze
  REFERRED_TO = { css: '#basic-table-referred-to-value' }.freeze
  SERVICE_TYPE = { css: '#basic-table-service-type-value' }.freeze

  def page_displayed?
    is_displayed?(CASE_VIEW)
  end

  def status
    text(CASE_STATUS)
  end

  def service_type
    text(SERVICE_TYPE)
  end

  def referred_to
    text(REFERRED_TO)
  end

  def primary_worker
    text(PRIMARY_WORKER)
  end

  def notes
    text(NOTES)
  end
end
