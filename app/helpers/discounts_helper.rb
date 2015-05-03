module DiscountsHelper
	def kind_options
		options_for_select(
			discount_kind_options
		)
	end

	def discount_kind_options
		Discount::KIND_NAMES.map{|k,v| [v, k]}
	end

	def affects_options
		options_for_select(
			[
				Shirt.name,
				Competition.name,
				Package.name,
				"Final Price"#,
				# Dance.name,
				# Klass.name
			]
		)
	end

	def discount_menu_options(discount)
		dropdown_options(
			links: [
				{
					name: "Edit",
					path: edit_hosted_event_discount_path(@event, discount)
				},
				{
					name: "Destroy",
					path: hosted_event_discount_path(@event, discount),
					options: {
						:method => :delete
					}
				}
			]
		)
	end
end
