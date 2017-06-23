# TODO: remove
module EventLoader
  def event(id: nil)
    id = (id or params[:hosted_event_id] or params[:event_id] or params[:id])

    operation = Operations::Event::Read.new(current_user, {
        id: id
      })

    operation.run
  end

  def set_event(id: nil)
    id = (id or params[:hosted_event_id] or params[:event_id] or params[:id])
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
