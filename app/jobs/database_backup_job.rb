# frozen_string_literal: true

class DatabaseBackupJob < ApplicationJob
  def perform
    Rake::Task['db:backup'].execute
  end
end
