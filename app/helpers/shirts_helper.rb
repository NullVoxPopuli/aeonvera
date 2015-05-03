module ShirtsHelper
	def shirt_menu_options(shirt)
		dropdown_options(
			links: [
				{
					name: "Edit",
					path: edit_hosted_event_shirt_path(@event, shirt)
				},
				{
					name: "Destroy",
					path: hosted_event_shirt_path(@event, shirt),
					options: {
						:method => :delete
					}
				}
			]
		)
	end
end
