# frozen_string_literal: true
# TODO: remove
module EventLoader
  def event(id: nil)
    id = (id || params[:hosted_event_id] || params[:event_id] || params[:id])

    operation = Operations::Event::Read.new(current_user, {
                                              id: id
                                            })

    operation.run
  end

  def set_event(id: nil)
    id = (id || params[:hosted_event_id] || params[:event_id] || params[:id])
    begin
      @event = current_user.hosted_events.find(id)
    rescue ActiveRecord::RecordNotFound => e
      # user is not hosting the requested event
      @event = current_user.collaborated_events.find(id)
    end
  end

  def current_event
    @event
  end
end
