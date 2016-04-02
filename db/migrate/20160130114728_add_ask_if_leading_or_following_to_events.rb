class AddAskIfLeadingOrFollowingToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ask_if_leading_or_following, :boolean, default: true, null: false
  end
end
