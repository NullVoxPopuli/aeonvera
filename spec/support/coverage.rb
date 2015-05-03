# for local test coverage metrics
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

# for test coverage reporting to codeclimate
if ENV['CODECLIMATE_REPO_TOKEN']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end
