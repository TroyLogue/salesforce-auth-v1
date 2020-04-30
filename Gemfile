source 'https://rubygems.org'

group :drivers do
  gem 'selenium-webdriver'
end

group :test_framework do
  gem 'rspec'
  gem 'rspec-expectations'
  gem 'rspec-retry'
end

group :test_harness do
  gem 'parallel_tests'
  gem 'rake'
end

group :test_data do
  gem 'faker'
  gem 'http' 
end

group :browserstack do
  # enables HTTP persistent connection in selenium bindings
  # https://github.com/browserstack/fast-selenium-scripts/tree/master/fast-selenium-gem
  gem 'fast-selenium'
end

group :debugging do
  gem 'byebug' # https://github.com/deivid-rodriguez/byebug
end

group :internal do
  gem 'api-integration', git: 'git@github.com:unite-us/api-integration-tests.git', branch: 'UU3-42351-gem'
end