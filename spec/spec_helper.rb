require 'bundler'
require 'fileutils'
require 'rubygems'
require_relative '../lib/browserstack_credentials'

# Specifies required dependencies per groups defined in Gemfile
# When spec files require spec_helper, they have access to all the package gems
# and do not need to require them individually
Bundler.require(:drivers, :test_framework, :test_harness, :test_data, :debugging)

# before and after hooks for every spec
RSpec.configure do |config|
  Selenium::WebDriver.logger.level = :error

  config.before(:each) do |example|
    case ENV['host']
    when 'browserstack'
      Bundler.require(:browserstack)
      caps = Selenium::WebDriver::Remote::Capabilities.new

      caps[:name] = example.metadata[:full_description]
      caps['browserstack.selenium_version'] = '3.5.2'
      caps['browserstack.local'] = 'false'
      caps['acceptSslCerts'] = 'true'
      # needed for IE 11 https://www.browserstack.com/automate/using-sendkeys-on-remote-IE11
      caps['browserstack.sendKeys'] = 'true'
      # uncomment the line below to capture screenshots at every command throughout the test
      # caps['browserstack.debug'] = 'true'
      # comment the line below to disable video recording
      # caps['browserstack.video'] = 'false'

      # env vars are passed by rake tasks
      caps['os'] = ENV['os']
      caps['os_version'] = ENV['os_version']
      caps['browser'] = ENV['browser']
      caps['browser_version'] = ENV['browser_version']

    # remote driver for browserstack
    @driver = Selenium::WebDriver.for(
      :remote,
      :url => "http://#{BROWSERSTACK_USERNAME}:#{BROWSERSTACK_ACCESS_KEY}@hub-cloud.browserstack.com/wd/hub",
      :desired_capabilities => caps)

    else
    # default browser is chrome; others can passed as variables
      case ENV['browser'] ||= 'chrome'
      when 'chrome'
        @driver = Selenium::WebDriver.for :chrome
      when 'chrome_headless'
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument('--headless')
        options.add_argument('--disable-gpu')
        options.add_argument('--no-sandbox')
        options.add_argument('--remote-debugging-port=9222')

        @driver = Selenium::WebDriver.for :chrome, options: options
      when 'firefox'
        @driver = Selenium::WebDriver.for :firefox
      when 'safari'
        @driver = Selenium::WebDriver.for :safari
      end
    end

    # default base_url is app-client staging; others can be passed as variables
    case ENV['base_url'] ||= 'http://app.uniteusdev.com'
    when 'devqa'
      ENV['base_url'] = 'http://app.uniteusdev.com' # add bucket here or pass at runtime
    when 'app_client_staging'
      ENV['base_url'] = 'http://app.uniteusdev.com'
    when 'app_client_training'
      ENV['base_url'] = 'http://app.uniteustraining.com'
    when 'app_client_production'
      ENV['base_url'] = 'http://app.uniteus.io'
    when 'ehr_staging'
      ENV['base_url'] = 'http://emr.uniteusdev.com'
    when 'ehr_training'
      ENV['base_url'] = 'http://emr.uniteustraining.com'
    when 'ehr_production'
      ENV['base_url'] = 'http://emr.uniteus.io'
    end
  end

  config.before(:each) do
    @driver.manage.delete_all_cookies
  end

  # config.verbose_retry = false # recommended for development mode
  config.verbose_retry = true # show retry status in spec process
  config.default_retry_count = 2

  # reporting
  config.after(:each) do |example|
    if ENV['host'] == 'browserstack'
      caps = Selenium::WebDriver::Remote::Capabilities.send(ENV['browser'])
      if example.exception.nil?
        # do not upload video if test passed
        caps['browserstack.video'] = 'false'
      else
        # true is the default value but stating explicitly for readability
        caps['browserstack.video'] = 'true'
      end
    else
      # if results directory doesn't exist, create it
      results_directory = File.join(Dir.pwd, 'results/')
      Dir.mkdir(results_directory) unless File.exists?(results_directory)

      if example.exception
        @driver.save_screenshot("#{results_directory}/#{example.metadata[:full_description]}-#{base_page.generate_timestamp}.png")
      end
    # uncomment the lines below to save screenshot on every test, not just on failure
    # else
    #   @driver.save_screenshot(File.join(Dir.pwd, "#{results_directory}/visual-checks/#{example.metadata[:full_description]}-#{page.generate_timestamp}.png"))
    end
    @driver.quit
  end
end
