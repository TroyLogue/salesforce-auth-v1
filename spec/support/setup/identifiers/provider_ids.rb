# frozen_string_literal: true

module Providers
  case ENV['ENVIRONMENT']
  when 'prod'
  when 'training'
    # TODO - update const names
    # QA Deployment CC in training
    CC_HARVARD = '2018360f-ff91-47fc-9b24-904e43fdb7f0'
    # QA Deployment Org 01
    ORG_YALE = '2e5f0b9a-d878-484f-b9df-e36b7b4ab405'
  when 'staging', 'devqa'
    ORG_YALE = '72af0e4d-8d83-4887-9c47-520632ae4861'
    CC_HARVARD = 'fdc38854-2b82-4ce1-9598-73278cea971b'
    ORG_COLUMBIA = '79ab235d-2ca3-4a46-a76e-fc9c655667af'
    ORG_PRINCETON = '0c58634f-fd19-422d-8c1a-c1f1a915e3cc'
    CC_QA_ADMIN = '1caa174e-694d-4cad-ab61-c60d1e062721'
  else
    raise "Missing required ENV['ENVIRONMENT']: prod, training, staging, devqa"
  end
end
