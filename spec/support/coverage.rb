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

SimpleCov.start do
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers/api'
  add_group 'Operations', 'app/operations'
  add_group 'Policies', 'app/policies'
  add_group 'Mailers', 'app/mailers'
  add_group 'Serializers', 'app/serializers'
  add_group 'Services', 'app/services'


  # filters.clear
  # add_filter '/app/controllers/[^a][^p][^i]'
  add_filter '/app/helpers/'
  add_filter '/app/decorators/'
  add_filter '/app/views/'
  add_filter '/gems/'
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/public/'
  add_filter '/db/'
end
