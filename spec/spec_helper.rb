require 'bundler'
require 'fileutils'
require 'rubygems'
require 'date'
require_relative '../lib/browserstack_credentials'

# Specifies required dependencies per groups defined in Gemfile
# When spec files require spec_helper, they have access to all the package gems
# and do not need to require them individually
Bundler.require(:default)

# Gives specs access to the data module that contains the methods
# to create clients, referrals and other data dependencies
Dir::glob('./spec/support/setup/data/*.rb').each { |file| require file }

# before and after hooks for every spec
RSpec.configure do |config|
  Selenium::WebDriver.logger.level = :error

  config.before(:each) do |example|
    begin
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
          :desired_capabilities => caps,
        )
        @driver.file_detector = lambda do |args|
          str = args.first.to_s
          str if File.exist?(str)
        end
      else
        # default browser is chrome; others can passed as variables
        case ENV['browser'] ||= 'chrome'
        when 'chrome'
          if ENV['host'] == 'docker'
            @driver = Selenium::WebDriver.for(:remote,
                                              :url => 'chrome://chrome:4444/wd/hub',
                                              :desired_capabilities => Selenium::WebDriver::Remote::Capabilities.chrome())
            @driver.file_detector = lambda do |args|
              str = args.first.to_s
              str if File.exist?(str)
              end
          else
            @driver = Selenium::WebDriver.for :chrome
          end
        when 'chrome_headless'
          options = Selenium::WebDriver::Chrome::Options.new
          options.add_argument('--headless')
          options.add_argument('--disable-gpu')
          options.add_argument('--no-sandbox')
          options.add_argument('--remote-debugging-port=9222')
          options.add_argument('--window-size=1280,720')

          @driver = Selenium::WebDriver.for :chrome, options: options
        when 'firefox'
          if ENV['host'] == 'docker'
            @driver = Selenium::WebDriver.for(:remote,
                                              :url => 'firefox://firefox:4444/wd/hub',
                                              :desired_capabilities => Selenium::WebDriver::Remote::Capabilities.firefox())

            @driver.file_detector = lambda do |args|
              str = args.first.to_s
              str if File.exist?(str)
            end
          else
            @driver = Selenium::WebDriver.for :firefox
          end
        when 'safari'
          @driver = Selenium::WebDriver.for :safari
        end
      end

      # default web_url, auth_url and  api_url is app-client staging; others can be passed as variables
      case ENV['environment'] ||= 'app_client_staging'
      when 'devqa'
        ENV['web_url'] = 'https://devqa.uniteusdev.com/uu3-do-98' # add bucket here or pass at runtime
        ENV['auth_url'] = 'ENTER_URL_HERE' # add bucket here or pass at runtime
        ENV['api_url'] = 'ENTER_URL_HERE' # add bucket here or pass at runtime
      when 'app_client_staging'
        ENV['web_url'] = 'https://app.uniteusdev.com'
        ENV['auth_url'] = 'https://app.auth.uniteusdev.com'
        ENV['api_url'] = 'https://api.uniteusdev.com'
        ENV['assistance_request_url'] = 'https://widgets.uniteusdev.com/assistance-request/7lCV515cZEd1oT8SJALFk2r_5YBjRxyRMdASLCju/'
        ENV['resource_directory_url'] = 'https://public-rd.uniteusdev.com'
      when 'app_client_training'
        ENV['web_url'] = 'https://app.uniteustraining.com'
        ENV['auth_url'] = 'https://app.auth.uniteustraining.com'
        ENV['api_url'] = 'https://api.uniteustraining.com'
      when 'app_client_production'
        ENV['web_url'] = 'https://app.uniteus.io'
        ENV['auth_url'] = 'https://app.auth.uniteus.io'
        ENV['api_url'] = 'https://api.uniteus.io'
        ENV['resource_directory_url'] = 'https://nccare.resource-directory.uniteus.io/'
      when 'ehr_staging'
        ENV['web_url'] = 'https://emr.uniteusdev.com'
        ENV['auth_url'] = 'https://emr.auth.uniteusdev.com'
        ENV['api_url'] = 'https://api.uniteusdev.com'
      when 'ehr_training'
        ENV['web_url'] = 'https://emr.uniteustraining.com'
        ENV['auth_url'] = 'https://emr.auth.uniteustraining.com'
        ENV['api_url'] = 'https://api.uniteustraining.com'
      when 'ehr_production'
        ENV['web_url'] = 'https://emr.uniteus.io'
        ENV['auth_url'] = 'https://emr.auth.uniteus.io'
        ENV['api_url'] = 'https://api.uniteus.io'
      when 'resource_directory_staging'
        ENV['web_url'] = 'https://public-rd.uniteusdev.com/'
        ENV['api_url'] = 'https://api.uniteusdev.com'
      when 'resource_directory_training'
        ENV['web_url'] = '' #currently no training env for PRD
        ENV['api_url'] = 'https://api.uniteustraining.com'
      when 'resource_directory_production'
        ENV['web_url'] = 'https://nccare.resource-directory.uniteus.io/'
        ENV['api_url'] = 'https://api.uniteus.io'
      end

      # define Mailtrap mailbox id for staging or training
      # default will be staging id
      case ENV['mailtrap_id'] ||= '99406'
      when 'app_client_staging'
        ENV['mailtrap_id'] = '99406'
      when 'app_client_training'
        ENV['mailtrap_id'] = '531559'
      end
    rescue Exception => e
      p "Exception in spec_helper.rb - before hook: #{e}"
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
    begin
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
        results_directory = File.join(Dir.pwd, 'results')
        Dir.mkdir(results_directory) unless File.exist?(results_directory)

        if example.exception
          @driver.save_screenshot("#{results_directory}/#{example.metadata[:full_description]}-#{Time.now.strftime('%m%d%Y%H%M%S')}.png")
        end
        # uncomment the lines below to save screenshot on every test, not just on failure
        # else
        #   @driver.save_screenshot(File.join(Dir.pwd, "#{results_directory}/visual-checks/#{example.metadata[:full_description]}-#{Time.now.strftime('%m%d%Y%H%M%S')}.png"))

      end
    rescue Exception => e
      p "Exception in spec_helper.rb - after hook: #{e}"
    end
    @driver.quit
  end
end
