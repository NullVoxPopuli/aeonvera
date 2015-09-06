module ApplicationHelper

  def small_datetime_select(form, field_name, label)
    form.label(field_name, label) +
    content_tag(:div, class: "row") do
      content_tag(:div, class: "small-6 columns") do
        form.label(field_name, "Date") +
        form.date_select(field_name, { required: true, include_blank: true }, { class: 'small-3' })
      end +
      content_tag(:div, class: "small-6 columns") do
        form.label(field_name, "Time") +
        form.time_select(field_name, { required: true, ignore_date: true , include_blank: true}, { class: 'small-3' })
      end
    end
  end

  def google_analytics_code
    %Q{
      <script>
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

        ga('create', 'UA-58633414-1', 'auto');
        ga('send', 'pageview');
        ga('set', '&uid', '#{current_user ? current_user.id : ''}');

      </script>
    }.html_safe
  end

  def event_url_for(item, action: nil)
    url_objects = [:hosted, @event, item]
    url_objects.unshift(action) if action.present? and action != :destroy
    url_for(url_objects)
  end

  def public_url(event, path)
    "http://" + event.subdomain + '.' + current_domain + request.port_string + path
  end

  def show_public_link?
    event = (defined?(current_event) ? current_event : @event)
    event_exists = event.present? && event.persisted?
    user_exists = (defined?(current_user) && current_user.present?)

    event_exists && user_exists &&
    !(
      current_user.hosted_event_ids.include?(event.id) ||
      current_user.collaborated_event_ids.include?(event.id)
    )
  end

  def hosted_event_links(event = @event)
    [
      {
        "At the Door" => "/event-at-the-door/16",
        "Edit" => edit_hosted_event_path(event)
      },
      {
        "Competitions" => hosted_event_competitions_path(event),
        "Packages" => hosted_event_packages_path(event),
        "Levels" => hosted_event_levels_path(event),
        "Pricing Tier Tables" => pricing_tables_hosted_event_path(event),
        "Discounts" => hosted_event_discounts_path(event),
        "Passes" => hosted_event_passes_path(event)
      },
      {
        "Registrants" => hosted_event_path(event),
        "Public Registration" => public_registration_hosted_event_path(event)
      },
      {
        "Charts" => charts_hosted_event_path(event),
        "Revenue Summary" => revenue_hosted_event_path(event)
      }
    ]
  end

  # Tables are used everywhere, and are pretty much all rendered
  # the same.
  #
  # collection: [], columns: []
  def item_table(args)
    render(partial: '/shared/item_table', locals: args)
  end

  def tooltip_tag(msg)
    content_tag(:span,
      "data-tooltip" => "",
      "data-width" => "200",
      class: "has-tip",
      title: msg
    ){
      tag("i", class: "fa fa-info-circle")
    }
  end

end
