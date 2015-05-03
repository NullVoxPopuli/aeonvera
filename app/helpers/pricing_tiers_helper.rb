module PricingTiersHelper
	def increases_when(pricing_tier)
		if pricing_tier.date.present?
			pricing_tier.date.to_date.to_s(:long)
		elsif pricing_tier.registrants.present?
			pricing_tier.registrants.to_s + " Registrants"
		else
			"Not Set"
		end
	end

	def pricing_tier_table_options(pricing_tier)
		dropdown_options(
			links: [
				{
					name: "Edit",
					path: edit_hosted_event_pricing_tier_path(@event, pricing_tier),
				},
				{
					name: "Destroy",
					path: hosted_event_pricing_tier_path(@event, pricing_tier),
					options: {
						method: "delete",
						remote: true
					}

				}
			]
		)
	end

	def form_packages
		@event.packages.map { |package|
			label_id = "pricing_tier_package_ids_#{package.id}"
			content_tag(:div, class: "checkbox"){
				check_box_tag("pricing_tier[package_ids][]", package.id, @pricing_tier.packages.include?(package), id: label_id) + 
				label_tag("pricing_tier[package_ids][]", package.name, "for" => label_id)
			}
		}.join.html_safe
	end
end
