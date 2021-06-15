# frozen_string_literal: true

module Networks
  case ENV['ENVIRONMENT']
  when 'prod'
  when 'training'
    # just for debugging - not actually Ivy in Training
    NETWORK_ID = '0c96386c-ed27-4c9b-bb90-6544701865eb'
  when 'staging', 'devqa'
    NETWORK_ID = 'd8e7a7f0-d4f1-459b-bab4-15802b371cae'
  else
    raise "Missing required ENV['ENVIRONMENT']: prod, training, staging, devqa"
  end
end
