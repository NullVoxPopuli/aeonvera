module EventLoader
  def event(id: nil)
    id = (id or params[:hosted_event_id] or params[:event_id] or params[:id])

    operation = Operations::Event::Read.new(current_user, {
        id: id
      })
    render json: operation.run
  end

  def set_event(id: nil)
    id = (id or params[:hosted_event_id] or params[:event_id] or params[:id])
    begin
      @event = current_user.hosted_events.find(id)
    rescue ActiveRecord::RecordNotFound => e
      # user is not hosting the requested event
      begin
        @event = current_user.collaborated_events.find(id)
      rescue ActiveRecord::RecordNotFound => e
        # check if we are on a subdomain, registering for the event
        begin
          if Subdomain.matches?(request)
            @event = Event.find_by_domain(request.subdomain)
          end
        rescue ActiveRecord::RecordNotFound => e
          # user has nothing to do with the requested event
          redirect_to action: "index"
        end
      end
    end

    unless @event
      flash[:error] = "Event Not Found"
      redirect_to root_path
    end

  end

  def current_event
    @event
  end
end
