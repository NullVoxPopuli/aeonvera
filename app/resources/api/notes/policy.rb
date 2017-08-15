# frozen_string_literal: true

module Api
  class NotePolicy < SkinnyControllers::Policy::Base
    def read_all?
      object.map(&:host).uniq.map do |host|
        is_at_least_a_collaborator?(host)
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

    def is_at_least_a_collaborator?(h = object.host)
      h.is_accessible_as_collaborator?(user)
    end
  end
end
