# frozen_string_literal: true
unless Rails.env.production?
  # quick helper method for showing SQL statements when
  # debugging through binding.pry
  def show_sql
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end
end
