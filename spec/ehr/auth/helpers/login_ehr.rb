# require_relative '../pages/login_email_ehr' # UU3-48209 uncomment login page-objects when task is addressed
# require_relative '../pages/login_password_ehr'

module LoginEhr
  attr_accessor :login_email_ehr, :login_password_ehr

  # TODO: UU3-26998 UU3-26999 UU3-27000 UU3-27001
  # manage users per staging, training, and prod envs
  # evaluate feasibility of reducing array of users and generating machine tokens
  TEST_USERS = [
    CC_HARVARD = 'harvard@auto.com'.freeze,
    NETWORK_DIRECTORY_USER = 'cc@bi.test'.freeze,
    NOLICENSE_MARTIN = 'martin@auto.com'.freeze,
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
