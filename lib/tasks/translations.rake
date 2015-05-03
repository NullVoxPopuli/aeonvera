# http://stackoverflow.com/questions/8829725/i18n-how-to-check-if-a-translation-key-value-pairs-is-missing
	task :i18n => :environment do
	def collect_keys(scope, translations)
		full_keys = []
		translations.to_a.each do |key, translations|
			new_scope = scope.dup << key
			if translations.is_a?(Hash)
				full_keys += collect_keys(new_scope, translations)
			else
				full_keys << new_scope.join('.')
			end
		end
		return full_keys
	end

	I18n.backend.send(:init_translations)
	all_keys = I18n.backend.send(:translations).collect do |check_locale, translations|
		collect_keys([], translations).sort
	end.flatten.uniq
	ap all_keys
	puts "#{all_keys.size} #{all_keys.size == 1 ? 'unique key' : 'unique keys'} found."

end
