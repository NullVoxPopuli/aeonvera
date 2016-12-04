# frozen_string_literal: true
module Api
  class NotePolicy < SkinnyControllers::Policy::Base
    def read_all?
      object.map(&:host).uniq.map do |host|
        host.is_at_least_a_collaborator?
      end.all?
    end

    def read?
      is_at_least_a_collaborator?
    end

    def update?
      is_at_least_a_collaborator?
    end

    def delete?
      is_at_least_a_collaborator?
    end

    def create?
      is_at_least_a_collaborator?
    end

    private

    def is_at_least_a_collaborator?
      object.host.is_accessible_as_collaborator?(user)
    end
  end
end
