module SideNavigationHelper


  def options_for(links: {})
    @dropdowns ||= 0

    content_tag(:a, "data-dropdown" => "drop#{@dropdowns += 1}",
                href: "#",
                style: "line-height: 46px; color: white;"
    ){
      content_tag(:i, :class => "fa fa-ellipsis-v") {}
    } +
      content_tag(:ul,
                  id: "drop#{@dropdowns}",
                  :class => "medium f-dropdown left",
                  "data-dropdown-content" => "",
    "aria-hidden"=>"false") {
      if links.is_a?(Hash)
        options_from_hash(links).html_safe
      elsif links.is_a?(Array)
        options_from_array(links).html_safe
      end
    }
  end

  # hash should be:
  #  link_name => link_url
  def options_from_hash(hash)
    result = ""
    hash.each { |name, url|
      result += content_tag(:li) { link_to name, url }
    }
    return result
  end

  # array should be of hashes
  def options_from_array(array)
    array.map { | hash |
      options_from_hash(hash)
    }.join(content_tag(:li, class: "divider") {content_tag(:hr){}})
  end


end
