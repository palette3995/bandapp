require "capybara/rspec"

Capybara.register_driver :remote_chrome do |app|
  url = ENV.fetch("SELENIUM_DRIVER_URL", nil)
  caps = ::Selenium::WebDriver::Remote::Capabilities.chrome(
    "goog:chromeOptions" => {
      "args" => [
        "no-sandbox",
        "headless",
        "disable-gpu",
        "window-size=1680,1050",
        "disable-infobars",
        "disable-gpu",
        "disable-dev-shm-usage",
        "disable-browser-side-navigation"
      ]
    }
  )
  Capybara::Selenium::Driver.new(app, browser: :remote, url: url, capabilities: caps)
end

Capybara.javascript_driver = :selenium_chrome_headless
Capybara.server = :puma

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, js: true, type: :system) do
    driven_by :remote_chrome
    Capybara.server_host = IPSocket.getaddress(Socket.gethostname)
    Capybara.server_port = 8080
    Capybara.app_host = "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end
end
