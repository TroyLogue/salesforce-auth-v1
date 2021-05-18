# frozen_string_literal: true

def run_in_parallel(tag:, processes: 1)
  system("parallel_rspec -n #{processes} --test-options '-r rspec --order random --tag #{tag} --format RspecJunitFormatter --out tmp/rspec$TEST_ENV_NUMBER.xml' spec")
end

namespace :jenkins do
  desc 'specs tagged app_client on chrome headless'
  task :app_client do
    ENV['browser'] = 'chrome_headless'
    ENV['environment'] = 'app_client_staging'
    exit run_in_parallel(tag: 'app_client')
  end

  task :UU3_52630 do
    ENV['browser'] = 'chrome_headless'
    ENV['environment'] = 'app_client_staging'
    exit run_in_parallel(tag: 'app_client')
  end

  # UU3-48322 DEBUG errors running tests in multiple processes:
  # To troubleshoot, use any tag(s) that efficiently reproduce the errors being debugged.
  # The end goal is to update the app_client task with 2 processes and to delete this task.
  task :app_client_parallel do
    ENV['browser'] = 'chrome_headless'
    ENV['environment'] = 'app_client_staging'
    exit run_in_parallel(tag: 'app_client', processes: 2)
  end

  desc 'specs tagged ehr on chrome headless'
  task :ehr do
    ENV['browser'] = 'chrome_headless'
    ENV['environment'] = 'ehr_staging'
    exit run_in_parallel(tag: 'ehr')
  end

  desc 'specs tagged resource_directory on chrome headless'
  task :resource_directory do
    ENV['browser'] = 'chrome_headless'
    ENV['environment'] = 'resource_directory_staging'
    exit run_in_parallel(tag: 'resource_directory')
  end

  desc 'specs tagged widgets on chrome headless'
  task :widgets do
    ENV['browser'] = 'chrome_headless'
    ENV['environment'] = 'widgets_staging'
    exit run_in_parallel(tag: 'widgets')
  end

  desc 'specs tagged consent on IE10'
  task :consent do
    ENV['host'] = 'browserstack'
    ENV['environment'] = 'consent_staging'
    ENV['os'] = 'Windows'
    ENV['os_version'] = '7'
    ENV['browser'] = 'ie'
    ENV['browser_version'] = '10.0'
    exit run_in_parallel(tag: 'consent_app')
  end
end

namespace :docker do
  desc 'Build End-To-End Test Cases'
  task :build do
    # If your ssh key has a passphrase, I recommend creating a second one that does not have a passphrase and placing it here
    `docker build . --tag=end-to-end --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)"`
  end

  desc 'Run App Client Test'
  task :run, :browser do |t, args|
    `docker network create qa-network`
    `docker run --network=qa-network -d -p 4444:4444 -v /dev/shm:/dev/shm --name #{args[:browser]} selenium/standalone-#{args[:browser]}:latest`
    `sleep 2` # waiting for ^container to be up and running
    `docker run --network=qa-network --name qa-tests --env-file .env.staging -e browser=#{args[:browser]} -e host=docker end-to-end rake "local:app_client_staging[#{args[:browser]}]"`
  end

  desc 'Clean'
  task :clean, :browser do |t, args|
    `docker stop #{args[:browser]}`
    `docker network rm qa-network`
    `docker rm qa-tests`
    `docker rm #{args[:browser]}`
  end
end

namespace :local do
  # example:
  # rake local:app_client_staging[chrome]
  desc 'Run app-client tests on staging by browser'
  task :app_client_staging, [:browser] do |t, args|
    ENV['browser'] = args[:browser]
    ENV['environment'] = 'app_client_staging'
    exit run_in_parallel(tag: 'app_client')
  end

  # example:
  # rake local:ehr_staging
  desc 'Run ehr tests on staging in chrome headless'
  task :ehr_staging, :browser do |t, args|
    ENV['browser'] = 'chrome_headless'
    ENV['environment'] = 'ehr_staging'
    exit run_in_parallel(tag: 'ehr')
  end

  # rake local:ehr_staging_tag[uuqa_1548]
  desc 'Run ehr tests on staging by tag'
  task :ehr_staging_tag, [:tag] do |t, args|
    ENV['browser'] = 'chrome_headless'
    ENV['environment'] = 'ehr_staging'
    exit run_in_parallel(tag: (args[:tag]).to_s)
  end

  # presupposes a url is set in spec_helper
  # example:
  # rake local:devqa[chrome,uuqa_292]
  desc 'Run tests on Dev QA bucket by browser and tag(s)'
  task :devqa, :browser, :tag do |t, args|
    ENV['browser'] = args[:browser]
    ENV['environment'] = 'devqa'
    exit run_in_parallel(tag: (args[:tag]).to_s)
  end

  # example:
  # rake local:resource_directory_staging[chrome]
  desc 'Run resource directory tests on staging by browser'
  task :resource_directory_staging, [:browser] do |t, args|
    ENV['browser'] = args[:browser]
    ENV['environment'] = 'resource_directory_staging'
    exit run_in_parallel(tag: 'resource_directory')
  end

  # UU3-48322 DEBUG errors running tests in multiple processes:
  # The purpose of this task is to compare chrome vs chrome_headless results
  # and any other troubleshooting toward stabilizing the app_client_parallel task in the jenkins namespace.
  task :app_client_parallel do
    ENV['browser'] = 'chrome'
    ENV['environment'] = 'app_client_staging'
    exit run_in_parallel(tag: 'referrals', processes: 2)
  end
end

namespace :browserstack do
  # see https://www.browserstack.com/automate/capabilities for OS and browser values

  # example:
  # rake browserstack:app_client_staging_by_browser_and_tag['OS X','Catalina','chrome','80.0',uuqa_292]
  desc 'Run tests by tag on app-client base url'
  task :app_client_staging_by_browser_and_tag, :os, :os_version, :browser, :browser_version, :tag do |t, args|
    ENV['host'] = 'browserstack'
    ENV['environment'] = 'app_client_staging'
    ENV['os'] = args[:os]
    ENV['os_version'] = args[:os_version]
    ENV['browser'] = args[:browser]
    ENV['browser_version'] = args[:browser_version]
    exit run_in_parallel(tag: (args[:tag]).to_s)
  end

  # example:
  # rake browserstack:app_client_staging_chrome['80.0']
  desc 'Run all app_client tests on Chrome'
  task :app_client_staging_chrome, :environment, :os, :browser do |t, args|
    ENV['host'] = 'browserstack'
    ENV['environment'] = 'app_client_staging'
    ENV['os'] = 'Windows'
    ENV['os_version'] = '10'
    ENV['browser'] = 'chrome'
    ENV['browser_version'] = args[:browser_version]
    exit run_in_parallel(tag: 'app_client')
  end

  # example:
  # rake browserstack:app_client_staging['Windows','7','internet_explorer','11.0']
  # rake browserstack:app_client_staging['OS X','Catalina','safari','13.0']
  desc 'Run tests tagged app_client by OS, browser, and browser version on app-client staging'
  task :app_client_staging, :os, :os_version, :browser, :browser_version do |t, args|
    ENV['host'] = 'browserstack'
    ENV['environment'] = 'app_client_staging'
    ENV['os'] = args[:os]
    ENV['os_version'] = args[:os_version]
    ENV['browser'] = args[:browser]
    ENV['browser_version'] = args[:browser_version]
    exit run_in_parallel(tag: 'app_client')
  end

  # example:
  # rake browserstack:app_client_staging_ie11['uuqa_292']
  # rake browserstack:app_client_staging_ie11['uuqa_292 --tag uuqa_293']
  desc 'Run app-client staging tests on IE 11 by tag(s)'
  task :app_client_staging_ie11, :tag do |t, args|
    ENV['host'] = 'browserstack'
    ENV['environment'] = 'app_client_staging'
    ENV['os'] = 'Windows'
    ENV['os_version'] = '7'
    ENV['browser'] = 'ie'
    ENV['browser_version'] = '11.0'
    exit run_in_parallel(tag: (args[:tag]).to_s)
  end

  # example:
  # rake browserstack:ehr_staging_ie10['uuqa_123 --tag uuqa_124']
  desc 'Run EHR staging tests on IE 10 by tag(s)'
  task :ehr_staging_ie10, :tag do |t, args|
    ENV['host'] = 'browserstack'
    ENV['environment'] = 'ehr_staging'
    ENV['os'] = 'Windows'
    ENV['os_version'] = '7'
    ENV['browser'] = 'ie'
    ENV['browser_version'] = '10.0'
    exit run_in_parallel(tag: (args[:tag]).to_s)
  end

  # example:
  # rake browserstack:ehr_staging_ie10
  desc 'Run all EHR staging tests on IE 10'
  task :ehr_staging_ie10_all do |t, args|
    ENV['host'] = 'browserstack'
    ENV['environment'] = 'ehr_staging'
    ENV['os'] = 'Windows'
    ENV['os_version'] = '7'
    ENV['browser'] = 'ie'
    ENV['browser_version'] = '10.0'
    exit run_in_parallel(tag: 'ehr')
  end
end
