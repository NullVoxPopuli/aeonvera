class AddPaymentEmailToEvents < ActiveRecord::Migration
	def change
		User.reset_column_information

		add_column :events, :payment_email, :string, null: false, default: ""

		# for events that don't have a payment email (which should be all of them)
		# use the host's email
		if Event.new.respond_to?(:payment_email)
			Event.all.each do |event|
				event.payment_email = event.hosted_by.email
				event.save_without_timestamping
			end
		end
	end
end
