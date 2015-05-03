class CreateEvents < ActiveRecord::Migration
	def change
		create_table :events do |t|
			t.string :name, null: false
			t.string :short_description
			t.string :domain, null: false

			t.datetime :starts_at, null: false
			t.datetime :ends_at, null: false
			t.datetime :mail_payments_end_at
			t.datetime :electronic_payments_end_at
			t.datetime :refunds_end_at

			t.boolean :has_volunteers, default: false, null: false
			t.string :volunteer_description

			# no housing
			# housing enabled
			# housing enabled - not accepting new registrants
			t.integer :housing_status, default: 0, null: false
			t.string :housing_nights, default: "#{Event::FRIDAY},#{Event::SATURDAY}"


			t.references :hosted_by

			t.datetime :deleted_at
			t.timestamps
		end
	end
end
