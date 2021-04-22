# frozen_string_literal: true

module Networks
  domain = ENV['environment'].split('_')[-1]
  case domain
  when 'prod'
  when 'training'
    # just for debugging - not actually Ivy in Training
    IVY = '0c96386c-ed27-4c9b-bb90-6544701865eb'
  when 'staging'
    IVY = 'd8e7a7f0-d4f1-459b-bab4-15802b371cae'
  when 'devqa'
    IVY = 'd8e7a7f0-d4f1-459b-bab4-15802b371cae'
  else
    raise "Missing required ENV['environment']: prod, training, staging, devqa"
  end
end
