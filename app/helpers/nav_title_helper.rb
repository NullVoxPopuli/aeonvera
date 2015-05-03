module NavTitleHelper
  def nav_title
    if show_public_link?
      public_nav_title
    elsif @event && @event.persisted?
      event_nav_title
    else
      default_nav_title
    end
  end

  def public_nav_title
    content_tag(:h1) {
      link_to current_event.name, public_registration_hosted_event_path(current_event, protocol: 'http')
    }
  end

  def event_nav_title
    content_tag(:h1, style: "display: inline-block;") {
      link_to( @event.name, hosted_event_path(@event) )
    } +
    options_for(links: hosted_event_links)
  end

  def default_nav_title
    content_tag(:h1) {
      link_to APPLICATION_CONFIG["app_name"], root_path
    }
  end

end
