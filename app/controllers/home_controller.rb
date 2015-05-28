class HomeController < ApplicationController
  respond_to :html, :json

  skip_before_filter :authenticate_user!, except: [:welcome]

  def index

  end

  def welcome
    # show dashboard of attended and hosted events
    # only show hosted events if people have hosted events
    # or are helping out with a hosted event
    @hosted_events = current_user.hosted_events
    @attendances = current_user.event_attendances
    @collaborated_events = current_user.collaborated_events
    upcoming_events
  end

  def about

  end

  def features

  end

  def calendar
    respond_with(upcoming_events)
  end

  def scenes
    @organizations = Organization.all
    respond_with(@organizations)
  end

  def terms_of_service

  end

  private

  def upcoming_events
    @upcoming_events = Event.upcoming
  end
end
