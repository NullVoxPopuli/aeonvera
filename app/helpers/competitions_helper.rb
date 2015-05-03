module CompetitionsHelper


	def competition_options(competition)
		options_for_select(
			Competition::KIND_NAMES.map{|k,v| [v, k]},
			selected: competition.kind
		)
	end

	def competition_menu_options(competition)
		dropdown_options(
			links: [
				{
					name: "Edit",
					path: edit_hosted_event_competition_path(@event, competition)
				},
				{
					name: "Destroy",
					path: hosted_event_competition_path(@event, competition), 
					options: {
						:method => :delete
					}
				}
			]
		)
	end
end
