# frozen_string_literal: true
RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  # https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
  config.include Warden::Test::Helpers, type: :feature

  Warden.test_mode!

  config.after(type: :feature) do |_example|
    Warden.test_reset!
    # if example.metadata[:type] == :feature and example.exception.present?
    #   save_and_open_page
    # end
  end
end
