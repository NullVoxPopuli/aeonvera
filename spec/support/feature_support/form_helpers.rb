module FormHelpers
  def registers_for_event
    # set the events domain to something non-dynamic
    # so the hosts file can properly directy capybara to the correct place
    @event.domain = 'testevent'
    @event.save

    @discount = create(:discount, code: 'discount', host: @event)
    @package = create(:package, event: @event)
    url = "http:#{@event.url}:#{Capybara.server_port}"

    visit url
    selects_package
    selects_orientation
    provides_address
    submit_form
  end

  def registers_for_organization
    unless @organization
      @organization = create(:organization, owner: @user)
    end

    unless @lesson
      @lesson = @organization.lessons.new(price: 45)
      @lesson.save
    end

    submit_form
  end

  def inputs_one_of_each_line_item
    @organization.line_items.each do |item|
      id = "attendance_line_item_ids_#{item.id}_quantity"

      fill_in id, with: '1'
    end
  end

  def fills_in_name
    first = "First"
    last = "Last"
    fill_in "attendance_attendee_first_name", with: first
    fill_in "attendance_attendee_last_name", with: last
    return first + " " + last
  end

  def fills_in_email
    email = "test@test.test"
    fill_in "attendance_attendee_email", with: email
    email
  end

  def click_anchor(id)
    find(id).click
  end

  def submit_form
    find('input[name="commit"]').click
  end

  def edit_registration
    find("a#edit_registration").click
  end

  def check_box_with_id(id)
    find(:css, id).set(true)
  end

  def uncheck_box_with_id(id)
    find(:css, id).set(false)
  end

  def is_volunteering
    check_box_with_id "#attendance_interested_in_volunteering"
  end

  def selects_package(package = @package)
    check_box_with_id "#attendance_package_id_#{@package.id}"
  end

  def selects_orientation(orientation = :leader)
    if [:leader, :lead].include?(orientation)
      check_box_with_id '#attendance_dance_orientation_lead'
    else
      check_box_with_id '#attendance_dance_orientation_follow'
    end
  end

  def provides_phone_number
    fill_in "attendance_metadata_phone_number", with: "123-555-1234"
  end

  def provides_address
    fill_in "attendance_metadata_address_line1", with: "1 Monument Cir"
    fill_in "attendance_metadata_address_state", with: "Indiana"
    fill_in "attendance_metadata_address_city", with: "Indianapolis"
    fill_in "attendance_metadata_address_zip", with: "46204"
  end
end
