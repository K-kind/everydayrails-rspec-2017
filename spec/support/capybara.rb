require 'capybara/rspec'

if chrome_url = ENV['SELENIUM_DRIVER_URL']
  RSpec.configure do |config|
    config.before(:each, type: :system) do
      driven_by :rack_test
    end
    config.before(:each, type: :system, js: true) do
      driven_by :selenium, using: :selenium_chrome_headless, screen_size: [800, 600], options: {
        browser: :remote,
        url: 'http://selenium_chrome:4444/wd/hub',
        # url: chrome_url,
        desired_capabilities: :chrome
      }
      Capybara.server_host = 'app'
      Capybara.app_host = 'http://app.local/'
      Capybara.default_max_wait_time = 5
    end
  end
else
  RSpec.configure do |config|
    config.before(:each, type: :system) do
      driven_by :rack_test
    end

    config.before(:each, type: :system, js: true) do
      driven_by :selenium_chrome_headless
    end
  end
end
