require "capybara/rspec"
require "selenium-webdriver"
require "webdrivers"

Capybara.register_driver :selenium_chrome_headless do |app|
  options = ::Selenium::WebDriver::Chrome::Options.new

  options.add_argument("--headless")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1680,1050")
  options.add_argument("--disable-gpu")
  options.add_argument("--disable-infobars")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--disable-browser-side-navigation")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :selenium_chrome_headless

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, js: true, type: :system) do
    driven_by :selenium_chrome_headless
  end
end
