require_relative '../base/assistance_request'
require_relative '../identifiers/provider_ids'
require_relative '../identifiers/machine_tokens'
require_relative '../identifiers/service_types_ids'
require_relative '../identifiers/ar_widget_form_ids'
require_relative '../identifiers/resolution_ids'

# helper methods to submit ar via widget form in the Columbia Network
module Setup
  module Data
    def self.submit_assistance_request_to_columbia_org
      assistance_request = Setup::AssistanceRequest.new
      assistance_request.create(access_token: COLUMBIA_AR_WIDGET_FORM_ID, service_type_id: Services::BENEFITS_DISABILITY_BENEFITS)
      assistance_request
    end

    def self.close_columbia_assistance_request(ar_id:)
      close_ar = Setup::CloseAssistanceRequest.new
      close_ar.close(token: MachineTokens::ORG_COLUMBIA, group_id: Providers::ORG_COLUMBIA, ar_id: ar_id, resolution: Resolutions::RESOLVED)
      close_ar
    end
  end
end