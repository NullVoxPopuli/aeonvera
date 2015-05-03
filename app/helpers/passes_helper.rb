module PassesHelper

	def passes_table
		item_table(
			klass: Pass,
			collection: @passes,
			columns: [
				:name,
				:intended_for,
				:discount_for,
				:attendee_name
			]
		)
	end

	def pass_menu_options(pass)
		dropdown_options(
			links: [
				{
					name: "Edit",
					path: edit_hosted_event_pass_path(@event, pass)
				},
				{
					name: "Destroy",
					path: hosted_event_pass_path(@event, pass),
					options: {
						:method => :delete
					}
				}
			]
		)
	end
end
