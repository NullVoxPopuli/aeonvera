module PackagesHelper

	def current_price_help
		msg = "This is calculated based on the initial price and the teir scheme."
		tooltip_tag(msg)
	end

	def package_menu_options(package)
		dropdown_option_menu_for(package, actions: [
			{name: "Registrants", action: :show}, :edit, :destroy]
		)
	end

end
