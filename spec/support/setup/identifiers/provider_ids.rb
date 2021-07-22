# frozen_string_literal: true

module Providers
  case ENV['ENVIRONMENT']
  when 'prod'
  when 'training'
    GENERAL_CC_01 = 'c97e0df3-2008-4b07-ae48-378867c98951' # End to End Tests - General P2P - CC [Technology Team Only][DO NOT USE]
    GENERAL_ORG_01 = '48caf668-d049-4319-8d17-fe306ca48ebc' # End to End Tests - General P2P - Org 01 [Technology Team Only][DO NOT USE]
    GENERAL_ORG_02 = '1cbe9c0d-6c5a-41ee-b518-b4929bcc6509' # End to End Tests - General P2P - Org 02 [Technology Team Only][DO NOT USE]
    GENERAL_ORG_03 = '68737fb3-7de2-48ad-9e22-0d6820d98d60' # End to End Tests - General P2P - Org 03 [Technology Team Only][DO NOT USE]
  when 'staging', 'devqa'
    GENERAL_CC_01 = 'fdc38854-2b82-4ce1-9598-73278cea971b' # Harvard
    GENERAL_ORG_01 = '72af0e4d-8d83-4887-9c47-520632ae4861' # Yale
    GENERAL_ORG_02 = '79ab235d-2ca3-4a46-a76e-fc9c655667af' # Columbia
    GENERAL_ORG_03 = '0c58634f-fd19-422d-8c1a-c1f1a915e3cc' # Princeton

    GENERAL_CC_02 = '1caa174e-694d-4cad-ab61-c60d1e062721' # QA Administrator

    PAYMENTS_ORG = 'b13c2706-3ee6-4261-8a79-0ec39b71a51f' # Speedy Wheels
  else
    raise "Missing required ENV['ENVIRONMENT']: prod, training, staging, devqa"
  end
end
