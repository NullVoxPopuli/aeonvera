# frozen_string_literal: true
# require 'capybara/poltergeist'
#
# Capybara.server_port = 3001
# #Capybara.javascript_driver = :webkit
# #if ENV["TRAVIS"]
# Capybara.default_wait_time = 8 # Seconds to wait before timeout error. Default is 2
#
# # Register slightly larger than default window size...
# Capybara.register_driver :poltergeist do |app|
#   Capybara::Poltergeist::Driver.new(app,
#     {
#       debug: false, # change this to true to troubleshoot
#       window_size: [3000, 3000] # this can affect dynamic layout
#     }
#   )
# end
#
# Capybara.javascript_driver = :poltergeist
# #end
#
#
# RSpec.configure do |config|
#
#   config.before(:each, js: true) do
#     # speeds up feature testing
#
#     if Capybara.javascript_driver == :webkit
#       # tracking
#       page.driver.block_url "https://stats.g.doubleclick.net"
#       page.driver.block_url "www.google-analytics.com"
#
#       # test event url
#       page.driver.allow_url("testevent.test.local.vhost")
#     else
#       page.driver.browser.url_blacklist = [
#         "https://stats.g.doubleclick.net",
#         "www.google-analytics.com"
#       ]
#     end
#   end
#
# end
