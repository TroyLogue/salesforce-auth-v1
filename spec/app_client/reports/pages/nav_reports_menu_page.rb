require_relative '../../../shared_components/base_page'

class NavReportsMenuPage < BasePage

  #Main nav reports menu objects
  FIRST_NETWORK_TAB = { css: '.network-0-btn' }

  #Reports menu objects
  POPULATIONS_TAB = { xpath: '//*[@id="network-report-tabs"]/div[1]/div/div' }
  SERVICES_TAB = { xpath: '//*[@id="network-report-tabs"]/div[2]/div/div' }
  NETWORK_PERFORMANCE_TAB = { xpath: '//*[@id="network-report-tabs"]/div[3]/div/div' }
  MILITARY_TAB = { xpath: '//*[@id="network-report-tabs"]/div[4]/div/div' }

  #Populations report
  CLIENT_COUNT = { xpath: '//*[@id="container"]/div/main/div/div[2]/div/div[2]/div/div/div/div/div/div[2]' }
  GENDER_CHART = { xpath: '/html/body/div/div/main/div/div[2]/div/div[3]/div[1]/div/div[2]/div/div' }
  RACE_CHART = { xpath: '/html/body/div/div/main/div/div[2]/div/div[4]/div[1]/div/div[2]/div/div' }
  ETHNICITY_CHART = { xpath: '/html/body/div/div/main/div/div[2]/div/div[4]/div[2]/div/div[2]/div/div' }
  AGE_GENDER_CHART = { xpath: '/html/body/div/div/main/div/div[2]/div/div[5]/div/div/div[2]/div/div' }
  RACE_ETHNICITY_CHART = { xpath: '/html/body/div/div/main/div/div[2]/div/div[6]/div/div/div[2]/div/div' }

  #Services report
  SERVICE_EPISODES_COUNT = { xpath: '//*[@id="container"]/div/main/div/div[2]/div/div[2]/div/div/div/div/div/div[2]' }
  SERVICE_EPISODES_CHART = { xpath: '/html/body/div/div/main/div/div[2]/div/div[3]/div[1]/div/div[2]/div/div' }
  CLOSED_CASES_CHART = { xpath: '/html/body/div/div/main/div/div[2]/div/div[5]/div/div/div[2]/div/div' }

  #Network performance report
  ORGANIZATIONS_COUNT = { css: '#container > div > main > div > div.container-fluid.reports__content > div > div.row > div:nth-child(1) > div > div > div > div > div.stat-data' }
  UNIQUE_NETWORK_USERS_COUNT = { css: '#container > div > main > div > div.container-fluid.reports__content > div > div.row > div:nth-child(2) > div > div > div > div > div.stat-data' }
  REFERRALS_SENT_LEADERBOARD = { css: '#container > div > main > div > div.container-fluid.reports__content > div > div:nth-child(3) > div.ui-base-card-header.with-border > div > h2' }
  REFERRALS_RECEIVED_TABLE = { css: '#container > div > main > div > div.container-fluid.reports__content > div > div:nth-child(4) > div.ui-base-card-header.with-border > div > h2' }

  #Military report
  AFFILIATION_CHART = { css: '#military-main > div:nth-child(2) > div:nth-child(1) > div > div.ui-base-card-header.with-border > div > h2' }
  SERVICE_STATUS_CHART = { css: '#military-main > div:nth-child(2) > div:nth-child(2) > div > div.ui-base-card-header.with-border > div > h2' }
  BRANCH_SERVICE_CHART = { css: '#military-main > div:nth-child(3) > div:nth-child(1) > div > div.ui-base-card-header.with-border > div > h2' }
  SERVICE_ERA_CHART = { css: '#military-main > div:nth-child(3) > div:nth-child(2) > div > div.ui-base-card-header.with-border > div > h2' }
  DISCHARGE_STATUS_CHART = { css: '#military-main > div:nth-child(4) > div:nth-child(1) > div > div.ui-base-card-header.with-border > div > h2' }
  BEEN_DEPLOYED_CHART = { css: '#military-main > div:nth-child(4) > div:nth-child(2) > div > div.ui-base-card-header.with-border > div > h2' }
  TRANSITIONING_STATUS_CHART = { css: '#military-main > div:nth-child(5) > div > div > div.ui-base-card-header.with-border > div > h2' }
  AFFILIATION_GENDER_CHART = { css: '#block-1 > div > div > div:nth-child(2) > div.ui-base-card-header.with-border > div > h2' }
  SERVICE_STATUS_GENDER_CHART = { css: '#block-1 > div > div > div:nth-child(3) > div.ui-base-card-header.with-border > div > h2' }
  BRANCH_SERVICE_GENDER_CHART = { css: '#block-1 > div > div > div:nth-child(4) > div.ui-base-card-header.with-border > div > h2' }
  SERVICE_ERA_GENDER_CHART = { css: '#block-1 > div > div > div:nth-child(5) > div.ui-base-card-header.with-border > div > h2' }
  TRANSITIONING_STATUS_GENDER_CHART = { css: '#block-2 > div > div > div:nth-child(2) > div.ui-base-card-header.with-border > div > h2' }
  SERVICE_ERA_BRANCH_SERVICE_CHART = { css: '#block-2 > div > div > div:nth-child(3) > div.ui-base-card-header.with-border > div > h2' }
  TRANSITIONING_STATUS_BRANCH_SERVICE_CHART = { css: '#block-2 > div > div > div:nth-child(4) > div.ui-base-card-header.with-border > div > h2' }

  #Click on the first network on the reports tab
  def go_to_first_network
    click(FIRST_NETWORK_TAB)
  end

  #Click on the populations tab
  def go_to_populations_report
    click(POPULATIONS_TAB)
  end

  #Click on the services tab
  def go_to_services_report
    click(SERVICES_TAB)
  end

  #Click on the network performance tab
  def go_to_network_performance_report
    click(NETWORK_PERFORMANCE_TAB)
  end

  #Click on the military tab
  def go_to_military_report
    click(MILITARY_TAB)
  end

  #Is populations report displayed
  def populations_report_displayed?
    is_displayed?(CLIENT_COUNT) &&
    is_displayed?(GENDER_CHART) &&
    is_displayed?(RACE_CHART) &&
    is_displayed?(ETHNICITY_CHART) &&
    is_displayed?(AGE_GENDER_CHART) &&
    is_displayed?(RACE_ETHNICITY_CHART)
  end

   #Is services report displayed
   def services_report_displayed?
    is_displayed?(SERVICE_EPISODES_COUNT) &&
    is_displayed?(SERVICE_EPISODES_CHART) &&
    is_displayed?(CLOSED_CASES_CHART)
   end

   #Is network performance report displayed
   def network_performance_report_displayed?
    is_displayed?(ORGANIZATIONS_COUNT) &&
    is_displayed?(UNIQUE_NETWORK_USERS_COUNT) &&
    is_displayed?(REFERRALS_SENT_LEADERBOARD) &&
    is_displayed?(REFERRALS_RECEIVED_TABLE)
   end

  #Scroll down to the bottom of the report to allow all charts to load
   def wait_for_military_report
    wait_for_spinner
    scroll_to(DISCHARGE_STATUS_CHART)
    scroll_to(TRANSITIONING_STATUS_CHART)
    scroll_to(SERVICE_STATUS_GENDER_CHART)
    scroll_to(SERVICE_ERA_GENDER_CHART)
    scroll_to(TRANSITIONING_STATUS_BRANCH_SERVICE_CHART)
   end

   #Is military report displayed
   def military_report_displayed?
    is_displayed?(AFFILIATION_CHART) &&
    is_displayed?(SERVICE_STATUS_CHART) &&
    is_displayed?(BRANCH_SERVICE_CHART) &&
    is_displayed?(SERVICE_ERA_CHART) &&
    is_displayed?(DISCHARGE_STATUS_CHART) &&
    is_displayed?(BEEN_DEPLOYED_CHART) &&
    is_displayed?(TRANSITIONING_STATUS_CHART) &&
    is_displayed?(AFFILIATION_GENDER_CHART) &&
    is_displayed?(SERVICE_STATUS_GENDER_CHART) &&
    is_displayed?(BRANCH_SERVICE_GENDER_CHART) &&
    is_displayed?(SERVICE_ERA_GENDER_CHART) &&
    is_displayed?(TRANSITIONING_STATUS_GENDER_CHART) &&
    is_displayed?(SERVICE_ERA_BRANCH_SERVICE_CHART) &&
    is_displayed?(TRANSITIONING_STATUS_BRANCH_SERVICE_CHART)
  end
end
