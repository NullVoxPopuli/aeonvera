# frozen_string_literal: true
# == Schema Information
#
# Table name: notes
#
#  id          :integer          not null, primary key
#  note        :text
#  host_id     :integer
#  host_type   :string
#  target_id   :integer
#  target_type :string
#  author_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Note < ActiveRecord::Base
  belongs_to :author, class_name: User.name
  belongs_to :target, polymorphic: true
  belongs_to :host, polymorphic: true
end
