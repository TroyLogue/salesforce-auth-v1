# frozen_string_literal: true

module AssistanceRequestForms
  case ENV['ENVIRONMENT']
  when 'prod'
  when 'training'
  when 'staging', 'devqa'
    AR_DEFAULT_FORM = 'C3woxqdt2LGhneTxQjT7lhVd8zDM4ueL3bN7uE37'
    AR_ALL_FIELDS_FORM = '7lCV515cZEd1oT8SJALFk2r_5YBjRxyRMdASLCju'
  else
    raise "Missing required ENV['ENVIRONMENT']: prod, training, staging, devqa"
  end
end
