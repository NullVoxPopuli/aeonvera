module RegisterHelper

  def packages(form)
    current_event.packages.map { |package|
      if package.past_expiration? || package.past_attendee_limit?
        content_tag(:strike) do
          label_with_price(package)
        end
      else
        form.label(:package_id) {
          form.radio_button(:package_id, package.id) +
          label_with_price(package)
        }
      end
    }.join.html_safe
  end

  def levels(form)
    current_event.levels.map { |level|
      form.label(:level_id){
        form.radio_button(:level_id, level.id) +
        level.name
      }
    }.join.html_safe
  end

  def line_items
    current_event.line_items.active.map{ |item|
      id = "attendance_line_item_ids_#{item.id}"
      label_tag(id){
        check_box_tag("attendance[line_item_ids][]", item.id, @attendance.line_items.include?(item), id: id) +
        label_with_price(item)
      }
    }.join.html_safe
  end

  def shirts
    current_event.shirts.map{ |item|
      id = "attendance_line_item_ids_#{item.id}"
      picture = ""
      if item.picture.present?
        picture = link_to(
          image_tag(item.picture.url(:thumb)),
          item.picture.url,
          target: "_blank"
        )
      end

      item.name + picture +

      content_tag(:div, :class => "row") do
        sizes = item.offered_sizes
        if sizes.present?
          number_of_columns = (12 / sizes.count).floor
          sizes.map do |size|
            id = "attendance_line_item_ids_#{item.id}_#{size}"
            shirt_data = @attendance.shirt_data
            quantity_for_size = shirt_data.try(:[], item.id.to_s).try(:[], size).try(:[], "quantity")

            content_tag(:div, :class => "small-#{number_of_columns} columns") do
              label = "#{size.upcase} - #{number_to_currency(item.price_for_size(size))}"
              label_tag(label) +
                label_tag("Quantity") +
                number_field_tag("attendance[metadata][shirts][#{item.id}][#{size}][quantity]", quantity_for_size, min: 0, placeholder: 0)
            end.html_safe
          end.join.html_safe
        end
      end.html_safe

    }.join.html_safe
  end

  def shirt_with_size_and_quantity_summary(line_item, attendance: @attendance)
    id = line_item.line_item_id

    shirt_data = attendance.shirt_data
    if shirt_data
      data = shirt_data[id.to_s]
      if data
        result = []
        data.each{|size, data|
          result << "#{data['quantity']} x #{size}" unless data['quantity'].to_i == 0
        }
        result.join(', ')
      end
    end
  end

  # @param [ActiveRecord::Base] item - object that implements name and current_price
  # @return [String] name and current price
  def label_with_price(item)
    price = item.try(:current_price) || item.try(:price)
    "#{item.name} - #{number_to_currency(price)}"
  end

end
