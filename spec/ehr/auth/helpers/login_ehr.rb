require_relative '../pages/login_email_ehr'
require_relative '../pages/login_password_ehr'

module LoginEhr
  attr_accessor :login_email_ehr, :login_password_ehr

  # TODO: UU3-26998 UU3-26999 UU3-27000 UU3-27001
  # manage users per staging, training, and prod envs
  # evaluate feasibility of reducing array of users and generating machine tokens
  TEST_USERS = [
    # cc user for testing business intelligence tracking
    BI_CC_USER = 'cc@bi.test'.freeze,
    # primary cc used in tests
    CC_HARVARD = 'harvard@auto.com'.freeze,
    # EHR user with screenings role
    EMR_SCREENINGS_USER = 'screenings@emr.com'.freeze,
    # EHR user with no screenings permissions
    EMR_NON_SCREENINGS_USER = 'noscreenings@emr.com'.freeze,
    # user configured with Tableau license for Insights feature
    INSIGHTS_USER = 'insights@auto.com'.freeze,
    # used in createIntakeOrgIntakeUser.js
    INTAKE_USER = 'intake@auto.com'.freeze,
    # same as nolicense; should be consolidated
    INVALID_USER = 'martin@auto.com'.freeze,
    # used in parts/login/nonLicensedUser.js
    NOLICENSE_MARTIN = 'martin@auto.com'.freeze,
    # used in 3 tests and 2 helper scripts
    ORG_ATLANTA = 'atlanta@auto.com'.freeze,
    # used in ~15 ui-tests
    ORG_COLUMBIA = 'columbia@auto.com'.freeze,
    # used in ~20 ui-tests
    ORG_NEWYORK = 'newyork@auto.com'.freeze,
    # used in 2 tests and 1 helper script
    ORG_PRINCETON = 'princeton@auto.com'.freeze,
    # primary org used in tests
    ORG_YALE = 'yale@auto.com'.freeze,
    # used in 3 tests
    REFERRAL_USER = 'referral@auto.com'.freeze,
    # used in reset pw spec - in Atlanta org
    RESET_PW_USER = 'reset_pw_org@auto.com'.freeze,
    # used in dashboardNavigationSN.js
    # might become obsolete or applied to referrals tests
    SUPER_USER = 'super@best.com'.freeze,
    # settings user, QA network
    SETTINGS_USER = 'qa.perms@auto.com'.freeze,
    # next gate temp user, this user is licensed in a NG tagged organization
    # and has New-Search Feature Flag enabled
    NEXTGATE_USER = 'test-perms9@auto.com'.freeze,
    # columbia org with New-Search Feature Flag enabled
    NEW_SEARCH_USER = 'client-search@auto.com'.freeze
  ]

  DEFAULT_PASSWORD = 'Uniteus1!'.freeze
  WRONG_PASSWORD = 'Uniteus'.freeze # can be passed to log_in_as method instance
  INSECURE_PASSWORD = 'password123'.freeze

  # TODO: UU3-26998 UU3-26999 UU3-27000 UU3-27001
  # manage users per staging, training, and prod envs
  # evaluate feasibility of reducing array of users and generating machine tokens
  def log_in_dashboard_as(email_address, password = DEFAULT_PASSWORD)
    login_email_ehr.get ''
    expect(login_email_ehr.page_displayed?).to be_truthy

    login_email_ehr.submit(email_address)
    expect(login_password_ehr.page_displayed?).to be_truthy
    login_password_ehr.select_dashboard
    login_password_ehr.submit(password)
  end

  def log_in_default_as(email_address, password = DEFAULT_PASSWORD)
    login_email_ehr.get ''
    expect(login_email_ehr.page_displayed?).to be_truthy

    login_email_ehr.submit(email_address)
    expect(login_password_ehr.page_displayed?).to be_truthy

    login_password_ehr.submit(password)
  end
end
