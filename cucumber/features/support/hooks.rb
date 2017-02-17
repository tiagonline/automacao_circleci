## Cucumber Definitions
Before do
  ## configure the chosen browser
  Capybara.configure do |config|
    config.default_driver = :selenium
    config.app_host = CONFIG['url']
  end
  ## set default max wait and maximize browser
  Capybara.default_max_wait_time = 60
end

After do
  ## kills instance when not headless
  unless BROWSER.eql?('chrome')
    Capybara.current_session.driver.quit
  end
end
