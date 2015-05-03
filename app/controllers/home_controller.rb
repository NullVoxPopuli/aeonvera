class HomeController < ApplicationController

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
    upcoming_events
  end

  def terms_of_service

  end

  private

  def upcoming_events
    table = Event.arel_table
    ends_at = table[:ends_at]
    event_id = table[:id]

    opening_date = PricingTier.arel_table[:date]
    now = Time.now

    @upcoming_events = Event.where(show_on_public_calendar: true).
      where(ends_at.gt(now)).
      order(table[:ends_at].asc)
      # includes(:opening_tier).
      # order('pricing_tiers.date')#(opening_date.asc)
      #where(opening_date.lt(now)).distinct
  end
end
