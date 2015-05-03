RSpec.configure do |config|
	config.include FactoryGirl::Syntax::Methods

	config.before(:suite) do
		# does not give helpful error messages >_<
		#FactoryGirl.lint
	end
end
