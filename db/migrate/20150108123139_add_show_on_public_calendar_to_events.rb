class AddShowOnPublicCalendarToEvents < ActiveRecord::Migration
  def change
    add_column :events, :show_on_public_calendar, :boolean, null: false, default: true
  end
end
