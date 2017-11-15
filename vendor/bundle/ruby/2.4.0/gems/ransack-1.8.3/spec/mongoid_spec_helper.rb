require 'machinist/object'
require 'sham'
require 'faker'
require 'pry'
require 'mongoid'
require 'ransack'

I18n.enforce_available_locales = false
Time.zone = 'Eastern Time (US & Canada)'
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'support', '*.yml')]

Dir[File.expand_path('../{mongoid/helpers,mongoid/support,blueprints}/*.rb',
  __FILE__)]
.each { |f| require f }

Sham.define do
  name        { Faker::Name.name }
  title       { Faker::Lorem.sentence }
  body        { Faker::Lorem.paragraph }
  salary      { |index| 30000 + (index * 1000) }
  tag_name    { Faker::Lorem.words(3).join(' ') }
  note        { Faker::Lorem.words(7).join(' ') }
  only_admin  { Faker::Lorem.words(3).join(' ') }
  only_search { Faker::Lorem.words(3).join(' ') }
  only_sort   { Faker::Lorem.words(3).join(' ') }
  notable_id  { |id| id }
end

RSpec.configure do |config|
  config.alias_it_should_behave_like_to :it_has_behavior, 'has behavior'

  config.before(:suite) do
    if ENV['DB'] == 'mongoid4'
      message = "Running Ransack specs with #{Mongoid.default_session.inspect
        }, Mongoid #{Mongoid::VERSION}, Moped #{Moped::VERSION
        }, Origin #{Origin::VERSION} and Ruby #{RUBY_VERSION}"
    else
      message = "Running Ransack specs with #{Mongoid.default_client.inspect
        }, Mongoid #{Mongoid::VERSION}, Mongo driver #{Mongo::VERSION}"
    end
    line = '=' * message.length
    puts line, message, line
    Schema.create
  end

  config.before(:all)   { Sham.reset(:before_all) }
  config.before(:each)  { Sham.reset(:before_each) }

  config.include RansackHelper
end

RSpec::Matchers.define :be_like do |expected|
  match do |actual|
    actual.gsub(/^\s+|\s+$/, '').gsub(/\s+/, ' ').strip ==
      expected.gsub(/^\s+|\s+$/, '').gsub(/\s+/, ' ').strip
  end
end

RSpec::Matchers.define :have_attribute_method do |expected|
  match do |actual|
    actual.attribute_method?(expected)
  end
end
