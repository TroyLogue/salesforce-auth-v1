# frozen_string_literal: true

module Providers

  domain = ENV['environment'].split('_')[-1]
  case domain
  when 'prod'
  when 'training'
    # refers to group United Coordination Center
    # which harvard@auto.com belongs to in Training
    # to update before merge
    CC_HARVARD = '6df9b6a0-d17a-4b39-80cb-397866df75e2'
  else
    ORG_YALE = '72af0e4d-8d83-4887-9c47-520632ae4861'
    CC_HARVARD = 'fdc38854-2b82-4ce1-9598-73278cea971b'
    ORG_COLUMBIA = '79ab235d-2ca3-4a46-a76e-fc9c655667af'
    ORG_PRINCETON = '0c58634f-fd19-422d-8c1a-c1f1a915e3cc'
  end
end
