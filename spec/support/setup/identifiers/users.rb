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
    EHR_USER = 'harvard@auto.com'
    INACTIVE_USER = 'bob@auto.com'
    # org with military focus and health insurance enabled
    MILITARY_AND_INSURANCE_ORG = 'columbia@auto.com'
    # next gate temp user, this user is licensed in a NG tagged organization
    # and has New-Search Feature Flag enabled
    NEXTGATE_USER = 'test-perms9@auto.com'
    # columbia org with New-Search Feature Flag enabled
    NEW_SEARCH_USER = 'client-search@auto.com'
    NON_EHR_USER = 'yale@auto.com'
    # org without military focus and without health insurance focus
    NON_MILITARY_NON_INSURANCE_ORG = 'princeton@auto.com'
    ORG_200_USERS = 'test-perms4@auto.com'
    ORG_NO_ADDRESS = 'chicago@auto.com'
    ORG_PRINCETON = 'princeton@auto.com'
    ORG_WITH_SCREENING_ROLE = 'newyork@auto.com'
    ORG_WITHOUT_SCREENING_ROLE = 'princeton@auto.com'
    ORG_YALE = 'yale@auto.com'
    ORG_COLUMBIA = 'columbia@auto.com'
    ORG_NEWYORK = 'newyork@auto.com'
    PAYMENTS_USER = ' yale@auto.com' # TBD: verify the feature flag does not break existing specs
    RESET_PW_USER = 'reset_pw_org@auto.com'
    SETTINGS_USER = 'qa.perms@auto.com'
    SCREENINGS_USER_MULTI_NETWORK = 'screenings@emr.com'
    USER_IN_MULTIPLE_PROVIDERS = 'seven-sisters@e2e.test'

    DEFAULT_PASSWORD = ENV['DEFAULT_PASSWORD']
  else
    raise "Missing required ENV['environment']: prod, training, staging, devqa"
  end
end
