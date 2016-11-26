# frozen_string_literal: true
module Api
  class MemberSerializer < ActiveModel::Serializer
    type 'members'

    attributes :id, :first_name, :last_name, :email
  end
end
