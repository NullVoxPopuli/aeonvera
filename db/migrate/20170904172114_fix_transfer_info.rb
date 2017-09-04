class FixTransferInfo < ActiveRecord::Migration
  def up
    add_column :registrations, :transferred_from_first_name, :string
    add_column :registrations, :transferred_from_last_name, :string
    add_column :registrations, :transferred_to_email, :string
    add_column :registrations, :transferred_to_year, :string
    add_column :registrations, :transferred_from_user_id, :integer

    migrate_data

    remove_column :registrations, :transferred_to_name
    remove_column :registrations, :transferred_to_user_id
  end

  def down
    add_column :registrations, :transferred_to_name, :string
    add_column :registrations, :transferred_to_user_id, :integer

    remove_column :registrations, :transferred_from_first_name
    remove_column :registrations, :transferred_from_last_name
    remove_column :registrations, :transferred_to_email
    remove_column :registrations, :transferred_to_year
    remove_column :registrations, :transferred_from_user_id
  end

  def migrate_data
    registrations = Registration.where.not(transferred_to_name: nil)

    registrations.each do |r|
      name = r.transferred_to_name
      # because people don't know how to use the name field
      first, *rest = name.split(' ')

      r.transferred_from_first_name = r.attendee_first_name
      r.transferred_from_last_name = r.attendee_last_name

      r.attendee_first_name = first
      r.attendee_last_name = rest.join(' ')

      r.save_without_timestamping
    end
  end
end
