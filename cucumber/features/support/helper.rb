# encoding: utf-8
# !/usr/bin/env ruby
require 'fileutils'
class Helper
  include Capybara::DSL
    # Custom commands
    def mouse_over(element_selector)
      element = Capybara.page.driver.browser.find_element(:css, element_selector)
      Capybara.page.driver.browser.mouse.move_to element
    end
end
