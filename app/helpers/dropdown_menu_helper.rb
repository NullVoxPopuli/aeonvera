module DropdownMenuHelper


  def dropdown_options(links: [], options: {})
    @dropdowns ||= 0

    align = options[:align] || "right"

    content_tag(:a, "data-dropdown" => "drop#{@dropdowns +=1 }", href: "#", class: "#{align}") {
      content_tag(:i, class: "fa fa-ellipsis-v") {}
    } +
    content_tag(:ul, id: "drop#{@dropdowns}", class: "f-dropdown", "data-dropdown-content" => "") {
      links.map do |link|
        content_tag(:li) {
          link_to( link[:name], link[:path], link[:options] )
        }
      end.join.html_safe
    }
  end

  def dropdown_option_menu_for(object, actions: [])
    links_list = build_dropdown_option_menu_links_list_for(object, actions: actions)
    dropdown_options(links: links_list)
  end

  def build_dropdown_option_menu_links_list_for(object, actions: [])
    result = []

    actions.each do |link_action|
      link_option = {
        name: link_action.to_s.titleize,
        path: event_url_for(object, action: link_action)
      }

      if link_action == :destroy
        link_option[:options] ||= {}
        link_option[:options][:methad] = :delete
      end
    end

    result
  end


end
