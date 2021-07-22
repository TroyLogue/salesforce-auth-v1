# frozen_string_literal: true

module PrimaryWorkers
  case ENV['ENVIRONMENT']
  when 'prod'
  when 'training'
    CC_01_USER = '34843b80-3209-4141-85c4-4836cfb7432d' # general-p2p-cc-01@qa.test
    ORG_01_USER = 'a08426b6-d98f-486a-b438-6667fc409911' # general-p2p-org-01@qa.test
    ORG_02_USER = 'a52802e7-fb21-4cff-805a-238afc722508' # general-p2p-org-02@qa.test
  when 'staging', 'devqa'
    CC_01_USER = 'eacbf6db-c730-4e0c-a35b-ff3812bb5292' # harvard@auto.com
    ORG_01_USER = '31c4ca27-7aa2-455f-90f2-e98b58ffd174' # yale@auto.com
    ORG_02_USER = '024028e8-7534-45d5-887e-49862d0bebf4' # columbiap@auto.com
    ORG_03_USER = '91b306e3-72fd-4dfb-939b-d4450e449da6' # princeton@auto.com
    PAYMENTS_USER = 'd9816e42-55bb-4370-a41e-ce8859708be6' # sam@speedywheels.com
  end
end
