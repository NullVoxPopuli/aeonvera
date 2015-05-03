module OrganizationsHelper

  def organization_menu_options(organization = @organization)
    dropdown_options(
      links: [
        {
          name: "View Public Page",
          path: public_organization_path(organization)
        },
        {
          name: "Edit",
          path: edit_organization_path(organization)
        },
        {
          name: "Destroy",
          path: organization_path(organization),
          options: {
            method: :delete
          }
        }
      ]
    )

  end

  def current_user_membership_active?
    if current_user
      current_user.is_member_of?(current_organization)
    end
  end

  def current_membership_status_text
    if current_user_membership_active?
      "Active"
    else
      "Not A Member"
    end
  end

  def current_membership_expiration_text
    if current_user
      expires = current_user.membership_expires_at(current_organization)
      if expires
        "Expires: " +
        l(expires, format: :with_zone)
      end
    end
  end

  def public_organization_path(organization)
    subdomain = organization.subdomain
    "#{request.protocol}#{subdomain}.#{request.host_with_port.gsub("www.", "")}#"
  end

  def image_for_line_item(item)
    picture = ""
    if item.respond_to?(:picture) && item.picture.present?
      picture = link_to(
        image_tag(item.picture.url(:thumb)),
        item.picture.url,
        target: "_blank"
      )
    end

    picture
  end

  def register_available_items(
    item_name, method_name: nil, target: "attendance",
    collection_name: "line_item", title: nil)

    method_name = item_name unless method_name
    title = item_name.titleize unless title

    line_item_data = @attendance.persisted? ? @attendance.line_item_data : nil
    collection = current_organization.send(method_name).order(:id)

    if collection.present?
      render(
        partial: "/register/line_item_with_description",
        locals: {
          line_item_data: line_item_data,
          collection: collection,
          title: title,
          target: target,
          collection_name: collection_name
        }
      )
    end
  end

end
