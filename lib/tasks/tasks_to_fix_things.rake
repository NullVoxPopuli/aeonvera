namespace :fix do

  task :refetch_stripe_data => :environment do

    orders = Order.where(
      paid: true,
      payment_method: Payable::Methods::STRIPE,
      paid_amount: 0.0
    )

    orders.each do |order|
      event = order.host
      token = event.integrations.first.config["stripe_user_id"]

      details = order.metadata["details"]

      if details
        charge_id = details["id"]

        if charge_id
          charge = Stripe::Charge.retrieve(charge_id, stripe_account: token)
          order.paid = false
          order.handle_stripe_charge(charge)
        end
      else
        # alternatively, look up transactions, and match by email
        # we'd probably want to cache this api call
        # charges = Stripe::Charge.all(limit: 200)
        # charges.select{|c| c.description == order.attendance.attendee_email }
      end
    end

  end


  task :rebuild_housing_associations => :environment do

    def fix_housing(h, attendance)
      if (h.class == HousingRequest and attendance.needs_housing?) or
        (h.class == HousingProvision and attendance.providing_housing?)
        h.host = attendance.host
        h.attendance_type = attendance.class.name
        h.save_without_timestamping
      else
        h.destroy
      end
    end

    def fix(h)
      puts 'fixing: ' + h.id.to_s + ' from:  ' + h.try(:host).try(:name)
      attendance = h.attendance
      if attendance.present?
        fix_housing(h, attendance)
      elsif h.attendance_id.present?
        attendance = Attendance.with_deleted.find_by_id(h.attendance_id)
        if attendance.present?
          fix_housing(h, attendance)
        end
      end

    end

    HousingRequest.all.each do |h|
      fix(h)
    end

    HousingProvision.all.each do |h|
      fix(h)
    end
  end

  task :rebuild_housing_attendances => :environment do
    HousingRequest.where(
      attendance_id: nil,
      attendance_type: EventAttendance.name
    ).each do |h|
      created_at = Attendance.arel_table[:created_at]
      updated_at = Attendance.arel_table[:updated_at]

      attendance_results = Attendance.where(
        created_at.gt(h.created_at - 1.second).and(created_at.lt(h.created_at + 1.second)))

      if attendance_results.count == 1
        h.attendance = attendance_results.first
        h.save_without_timestamping
      else
        # expand search
        attendance_results = Attendance.where(
          created_at.gt(h.created_at - 10.second).and(created_at.lt(h.created_at + 10.second)))

        if attendance_results.count == 1
          h.attendance = attendance_results.first
          h.save_without_timestamping
        end
      end


    end
  end

end
