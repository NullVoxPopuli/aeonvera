require 'rails_helper'

describe Api::LineItemsController, type: :request do
  base_path = '/api/line_items'

  context 'is logged in and owns the event' do
    it_behaves_like(
      'resource_accessed_by_event_owner', {
        type: 'line-items',
        factory: :line_item,
        base_path: base_path,
        event_relationship_name: :host,
        # undestroy: true
      }
    )
  end

  context 'is logged in but does not own the event' do
    it_behaves_like(
      'resource_accessed_by_random_user', {
        type: 'line-items',
        factory: :line_item,
        base_path: base_path,
        event_relationship_name: :host,
        # TODO: is this needed? should everything be accessed via index?
        # TODO: figure out why
        show: 200,
        index: 200
      }
    )
  end

  context 'is logged in and the user is a collaborator' do
    it_behaves_like(
      'resource_accessed_by_collaborator_with_full_access', {
        type: 'line-items',
        factory: :line_item,
        base_path: base_path,
        event_relationship_name: :host,
        destroy: 403
      }
    )
  end
end
