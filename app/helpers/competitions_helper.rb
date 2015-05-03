module CompetitionsHelper


	def competition_options(competition)
		options_for_select(
			Competition::KIND_NAMES.map{|k,v| [v, k]},
			selected: competition.kind
		)
	end

	def competition_menu_options(competition)
		dropdown_option_menu_for(competition, [:edit, :destroy])
	end
end
