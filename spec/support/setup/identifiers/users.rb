# frozen_string_literal: true

module Users
  domain = ENV['environment'].split('_')[-1]
  case domain
  when 'prod'
  when 'training'
    CC_USER = 'harvard@auto.com'
    DEFAULT_PASSWORD = ENV['DEFAULT_PASSWORD']
  when 'staging', 'devqa'
    CC_USER = 'harvard@auto.com'
    CC_QA_ADMIN = 'qa.perms@auto.com'
    ORG_NO_ADDRESS = 'chicago@auto.com'
    ORG_PRINCETON = 'princeton@auto.com'
    ORG_WITH_SCREENING_ROLE = 'newyork@auto.com'
    ORG_WITHOUT_SCREENING_ROLE = 'princeton@auto.com'
    ORG_YALE = 'yale@auto.com'
    ORG_COLUMBIA = 'columbia@auto.com'
    ORG_NEWYORK = 'newyork@auto.com'
    SCREENINGS_USER_MULTI_NETWORK = 'screenings@emr.com'
    DEFAULT_PASSWORD = ENV['DEFAULT_PASSWORD']
  else
    raise "Missing required ENV['environment']: prod, training, staging, devqa"
  end
end
