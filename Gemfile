# frozen_string_literal: true

source 'https://rubygems.org'

# drivers
gem 'selenium-webdriver'

# test_framework
gem 'capybara'
gem 'capybara-email'
gem 'mailslurp_client'
gem 'page-object'
gem 'rspec'
gem 'rspec-expectations'
gem 'rspec-retry'
gem 'typhoeus'

# test_harness
gem 'parallel_tests'
gem 'rake'

# test_data
gem 'dotenv'
gem 'easy_poller'
gem 'faker'
gem 'http'
gem 'httparty'
gem 'io-wait'
gem 'nokogiri'


# browserstack
# enables HTTP persistent connection in selenium bindings
# https://github.com/browserstack/fast-selenium-scripts/tree/master/fast-selenium-gem
gem 'fast-selenium'

# reporting used for Jenkins jobs
gem 'rspec_junit_formatter'

# debugging
gem 'byebug' # https://github.com/deivid-rodriguez/byebug

# internal
gem 'uniteus-api-client', git: 'git@github.com:unite-us/api-integration-tests.git'

group :test, :development, :training do
  gem 'knapsack_pro'
end
