# frozen_string_literal: true

# require_relative '../pages/login_email' # UU3-48209 uncomment login page-objects when task is addressed
# require_relative '../pages/login_password'

module Login
  attr_accessor :login_email, :login_password

  # TODO: UU3-26998 UU3-26999 UU3-27000 UU3-27001
  # manage users per staging, training, and prod envs
  # evaluate feasibility of reducing array of users and generating machine tokens
  TEST_USERS = [
    # cc user for testing business intelligence tracking
    BI_CC_USER = 'cc@bi.test',
    # primary cc used in tests
    CC_HARVARD = 'harvard@auto.com',
    # user configured with Tableau license for Insights feature
    INSIGHTS_USER = 'insights@auto.com',
    # used in createIntakeOrgIntakeUser.js
    INTAKE_USER = 'intake@auto.com',
    # used in parts/login/nonLicensedUser.js
    INACTIVE_BOB = 'bob@auto.com',
    # used in 3 tests and 2 helper scripts
    ORG_ATLANTA = 'atlanta@auto.com',
    # used in ~15 ui-tests, org with referral permissions to other network
    ORG_COLUMBIA = 'columbia@auto.com',
    # used in ~20 ui-tests
    ORG_NEWYORK = 'newyork@auto.com',
    # used in 2 tests and 1 helper script
    ORG_PRINCETON = 'princeton@auto.com',
    # primary org used in tests
    ORG_YALE = 'yale@auto.com',
    # used in 3 tests
    REFERRAL_USER = 'referral@auto.com',
    # used in reset pw spec - in Atlanta org
    RESET_PW_USER = 'reset_pw_org@auto.com',
    # used in dashboardNavigationSN.js
    # might become obsolete or applied to referrals tests
    SUPER_USER = 'super@best.com',
    # settings user, QA network
    SETTINGS_USER = 'qa.perms@auto.com',
    # next gate temp user, this user is licensed in a NG tagged organization
    # and has New-Search Feature Flag enabled
    NEXTGATE_USER = 'test-perms9@auto.com',
    # columbia org with New-Search Feature Flag enabled
    NEW_SEARCH_USER = 'client-search@auto.com',
    # used to test provider-selector features
    USER_IN_MULTIPLE_PROVIDERS = 'seven-sisters@e2e.test',
    # user with valid address
    ORG_UPENN = 'upenn@auto.com',
    # user with no address in org with no address
    ORG_CHICAGO = 'chicago@auto.com',
    # user in cc with 200+ users
    ORG_200_USERS = 'test-perms4@auto.com'
  ].freeze

  DEFAULT_PASSWORD = 'Uniteus1!'
  WRONG_PASSWORD = 'Uniteus' # can be passed to log_in_as method instance
  INSECURE_PASSWORD = 'password123'

  def log_in_as(email_address, password = DEFAULT_PASSWORD)
    login_email.get ''
    expect(login_email.page_displayed?).to be_truthy

    login_email.submit(email_address)
    expect(login_password.page_displayed?).to be_truthy

    login_password.submit(password)
  end
end
