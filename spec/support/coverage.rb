# for local test coverage metrics
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

# for test coverage reporting to codeclimate
# don't know why - but env variables aren't working for this
ENV['CODECLIMATE_REPO_TOKEN']='1eeb995da67e27b3df3f6cff8049df742e0aa73ce0e1505d2ffa2323b1a98896'

if ENV['CODECLIMATE_REPO_TOKEN'] && ENV['TRAVIS']
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end
