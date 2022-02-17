# frozen_string_literal: true

module Users
  case ENV['ENVIRONMENT']
  when 'prod'
    # End to End Tests - General P2P - [Technology Team Only][DO NOT USE]
    CC_01_USER = 'general-p2p-cc-01@qa.test'
    ORG_01_USER = 'general-p2p-org-01@qa.test'
    ORG_02_USER = 'general-p2p-org-02@qa.test'
    ORG_03_USER = 'general-p2p-org-03@qa.test'
    DEFAULT_PASSWORD = ENV['DEFAULT_PASSWORD']
    DEFAULT_PASSWORD_15 = ENV['DEFAULT_PASSWORD_15']
  when 'training'
    # End to End Tests - General P2P - [Technology Team Only][DO NOT USE]
    CC_01_USER = 'general-p2p-cc-01@qa.test'
    ORG_01_USER = 'general-p2p-org-01@qa.test'
    ORG_02_USER = 'general-p2p-org-02@qa.test'
    ORG_03_USER = 'general-p2p-org-03@qa.test'
    DEFAULT_PASSWORD = ENV['DEFAULT_PASSWORD']
    DEFAULT_PASSWORD_15 = ENV['DEFAULT_PASSWORD_15']
    SALESFORCE_USER = ENV['SALESFORCE_USER']
    SALESFORCE_DEFAULT_PASSWORD = ENV['SALESFORCE_DEFAULT_PASSWORD']
  when 'staging', 'devqa'
    # Ivy League Network
    CC_01_USER = 'harvard@auto.com'
    ORG_01_USER = 'yale@auto.com'
    ORG_02_USER = 'columbia@auto.com'
    ORG_03_USER = 'princeton@auto.com'
    EHR_USER = 'harvard@auto.com'
    NON_EHR_USER = 'yale@auto.com'
    ORG_WITHOUT_SCREENING_ROLE = 'princeton@auto.com'
    # org with military focus and health insurance enabled
    MILITARY_AND_INSURANCE_ORG = 'columbia@auto.com'
    # org without military focus and without health insurance focus
    NON_MILITARY_NON_INSURANCE_ORG = 'princeton@auto.com'
    USER_IN_MULTIPLE_PROVIDERS = 'seven-sisters@e2e.test'
    INSIGHTS_USER = 'insights-automated@bi.test'
    #salesforce
    SALESFORCE_USER = 'fine-01curls@icloud.com'
    SALESFORCE_DEFAULT_PASSWORD = ENV['SALESFORCE_DEFAULT_PASSWORD']

    # QA Network
    CC_02_USER = 'qa.perms@auto.com'
    SETTINGS_USER = 'qa.perms@auto.com'

    # Developer Playground [DEVS ONLY] Network
    INACTIVE_USER = 'bob@auto.com'
    ORG_200_USERS = 'test-perms4@auto.com'
    SCREENINGS_USER_MULTI_NETWORK = 'screenings@emr.com'

    # Net Network
    # User licensed in a NG tagged organization
    NEXTGATE_USER = 'test-perms9@auto.com'

    # Abdoulaye Network
    ORG_NO_ADDRESS = 'chicago@auto.com'
    CC_03_WITH_SCREENING_ROLE = 'newyork@auto.com'
    CC_03_NETWORK_DIRECTORY = 'newyork@auto.com'
    RESET_PW_USER = 'reset_pw_org@auto.com'

    # Healthy Opportunities
    ORG_PAYMENTS_USER = 'sam@speedywheels.test'

    DEFAULT_PASSWORD = ENV['DEFAULT_PASSWORD']
    DEFAULT_PASSWORD_15 = ENV['DEFAULT_PASSWORD_15']
    NEW_RESET_PASSWORD = ENV['NEW_RESET_PASSWORD']
  else
    raise "Missing required ENV['ENVIRONMENT']: prod, training, staging, devqa"
  end
end
