module LineItemsHelper


	def line_item_menu_options(line_item)
		dropdown_options(
			links: [
				{
					name: "Edit",
					path: edit_hosted_event_line_item_path(@event, line_item)
				},
				{
					name: "Destroy",
					path: hosted_event_line_item_path(@event, line_item),
					options: {
						:method => :delete
					}
				}
			]
		)
	end
end
