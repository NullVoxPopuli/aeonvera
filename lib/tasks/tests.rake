require 'rspec/core/rake_task'

namespace :spec do

  desc 'Run all specs in spec directory'
  RSpec::Core::RakeTask.new(:api) do |task|
    # file_list = FileList['spec/**/*_spec.rb']
    #
    # # exclude features
    # file_list = file_list.exclude("spec/features/**/*_spec.rb")
    # # exclude controllers
    # file_list = file_list.exclude("spec/controllers/**/*_spec.rb")
    # # include api controllers
    # file_list = file_list.exclude("spec/#{exclude}/**/*_spec.rb")
    #
    #
    # task.pattern = file_list

    task.pattern = [
      'spec/controllers/api',
      'spec/mailers',
      'spec/models',
      'spec/operations',
      'spec/policies',
      'spec/routing',
      'spec/services'
    ]
  end

end
