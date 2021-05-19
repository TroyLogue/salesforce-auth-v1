# frozen_string_literal: true

require 'bundler'
require 'fileutils'
require 'rubygems'
require 'date'
require_relative './app_client/auth/pages/login_email' # UU3-48209 Currently all tests login through the UI and so these files are needed throughout the repo.
require_relative './app_client/auth/pages/login_password' # With UU3-48209 we should not require login_email and login_password in the spec_helper, and only require them in specs testing login.
# adding login pages for EHR as well:
require_relative './ehr/auth/pages/login_email_ehr' # UU3-48209 Currently all tests login through the UI and so these files are needed throughout the repo.
require_relative './ehr/auth/pages/login_password_ehr' # With UU3-48209 we should not require login_email and login_password in the spec_helper, and only require them in specs testing login.

# Specifies required dependencies per groups defined in Gemfile
# When spec files require spec_helper, they have access to all the package gems
# and do not need to require them individually
Bundler.require(:default)

# Setting and grabbing environment specific vars
ENV['environment'] ||= 'app_client_staging'

domain = ENV['environment'].split('_')[-1]
application = ENV['environment'].gsub('_' + domain, '')

Dotenv.load(".env.#{domain}")
ENV['web_url'] = ENV[application + '_url']
ENV['auth_url'] = ENV[application + '_auth_url']

# Gives specs access to the support setup modules that contain the methods
# to create data needed for test cases
Dir.glob('./spec/support/**/*/*.rb').sort.each { |file| require file }

# before and after hooks for every spec
RSpec.configure do |config|
  Selenium::WebDriver.logger.level = :error

  config.before(:each) do |example|
    case ENV['host']
    when 'browserstack'
      Bundler.require(:browserstack)
      caps = Selenium::WebDriver::Remote::Capabilities.new

      caps[:name] = example.metadata[:full_description]
      caps['browserstack.selenium_version'] = '3.141.59'
      caps['browserstack.local'] = 'false'
      caps['acceptSslCerts'] = 'true'
      # needed for IE 11 https://www.browserstack.com/automate/using-sendkeys-on-remote-IE11
      caps['browserstack.sendKeys'] = 'true'
      caps['browserstack.console'] = 'errors'
      caps['browserstack.networkLogs'] = 'true'
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
        url: "http://#{ENV['BROWSERSTACK_USERNAME']}:#{ENV['BROWSERSTACK_ACCESS_KEY']}@hub-cloud.browserstack.com/wd/hub",
        desired_capabilities: caps
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
                                            url: 'http://chrome:4444/wd/hub',
                                            desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome)
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
        options.add_argument('--disable-dev-shm-usage')
        options.add_argument('--window-size=1280,720')
        options.add_argument('—-disk-cache-size=0')

        @driver = Selenium::WebDriver.for :chrome, options: options
      when 'firefox'
        if ENV['host'] == 'docker'
          @driver = Selenium::WebDriver.for(:remote,
                                            url: 'http://firefox:4444/wd/hub',
                                            desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox)

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
  rescue Exception => e
    p "Exception in spec_helper.rb - before hook: #{e}"
  end

  config.before(:each) do
    @driver.manage.delete_all_cookies
  end

  if ENV['RETRY'] == 'false'
    config.verbose_retry = false # recommended for development mode
  else
    config.verbose_retry = true # show retry status in spec process
    config.display_try_failure_messages = true
    config.default_retry_count = 2
  end

  # From rspec-core: This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # reporting
  config.after(:each) do |example|
    begin
      if ENV['host'] == 'browserstack'
        caps = Selenium::WebDriver::Remote::Capabilities.send(ENV['browser'])
        caps['browserstack.video'] = if example.exception.nil?
                                       # do not upload video if test passed
                                       'false'
                                     else
                                       # true is the default value but stating explicitly for readability
                                       'true'
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
