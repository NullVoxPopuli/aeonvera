# Everyone is to have a set of permissions for:
# - the whole app
# - for each event they are collaborating on
module DefaultPermissions

  KIND = 0
  DEFAULT_ACCESS = 1
  DESCRIPTION = 2
  VISIBILITY_PROC = 3
  ACCESS_PROC = 4

  OBJECT = 0
  ACCESS = 1

  UNRELATED = 0
  OWNER = 1
  COLLABORATOR = 2
  RESTRICT_COLLABORATORS = [false, true, false]

  # (present action)_(object singular)
  PERMISSIONS = {
    # name: [KIND, DEFAULT_ACCESS, DESCRIPTION, VISIBLITY_PROC, ACCESS_PROC]

    # CRUD actions on objects
    edit_event:   [OBJECT, RESTRICT_COLLABORATORS],
    delete_event: [OBJECT, RESTRICT_COLLABORATORS, nil, ->(e, user){ e.hosted_by == user }, ->(e, user){ e.hosted_by == user }],
    create_event: [ACCESS, RESTRICT_COLLABORATORS],

    edit_payment_processors:   [OBJECT, RESTRICT_COLLABORATORS],
    # delete_payment_processors: [OBJECT, RESTRICT_COLLABORATORS],
    # create_payment_processors: [OBJECT, RESTRICT_COLLABORATORS],

    edit_levels:   [OBJECT, RESTRICT_COLLABORATORS],
    delete_levels: [OBJECT, RESTRICT_COLLABORATORS],
    create_levels: [OBJECT, RESTRICT_COLLABORATORS],

    edit_pass:   [OBJECT, RESTRICT_COLLABORATORS],
    delete_pass: [OBJECT, RESTRICT_COLLABORATORS],
    create_pass: [OBJECT, RESTRICT_COLLABORATORS],
    view_passes: [OBJECT, true],

    edit_discount:   [OBJECT, RESTRICT_COLLABORATORS],
    delete_discount: [OBJECT, RESTRICT_COLLABORATORS],
    create_discount: [OBJECT, RESTRICT_COLLABORATORS],

    edit_package:   [OBJECT, RESTRICT_COLLABORATORS],
    delete_package: [OBJECT, RESTRICT_COLLABORATORS],
    create_package: [OBJECT, RESTRICT_COLLABORATORS],

    edit_pricing_tier:   [OBJECT, RESTRICT_COLLABORATORS],
    delete_pricing_tier: [OBJECT, RESTRICT_COLLABORATORS],
    create_pricing_tier: [OBJECT, RESTRICT_COLLABORATORS],

    edit_competition:   [OBJECT, RESTRICT_COLLABORATORS],
    delete_competition: [OBJECT, RESTRICT_COLLABORATORS],
    create_competition: [OBJECT, RESTRICT_COLLABORATORS],

    edit_line_item:   [OBJECT, RESTRICT_COLLABORATORS],
    delete_line_item: [OBJECT, RESTRICT_COLLABORATORS],
    create_line_item: [OBJECT, RESTRICT_COLLABORATORS],

    edit_shirt:   [OBJECT, RESTRICT_COLLABORATORS],
    delete_shirt: [OBJECT, RESTRICT_COLLABORATORS],
    create_shirt: [OBJECT, RESTRICT_COLLABORATORS],

    edit_raffle:   [OBJECT, RESTRICT_COLLABORATORS],
    delete_raffle: [OBJECT, RESTRICT_COLLABORATORS],
    create_raffle: [OBJECT, RESTRICT_COLLABORATORS],
    run_raffle:    [OBJECT, RESTRICT_COLLABORATORS],

    edit_organization:   [OBJECT, RESTRICT_COLLABORATORS],
    delete_organization: [OBJECT, RESTRICT_COLLABORATORS, nil, ->(e, user){ e.hosted_by == user }, ->(e, user){ e.owner == user }],
    create_organization: [ACCESS, RESTRICT_COLLABORATORS, nil, nil],

    edit_collaborator: [OBJECT, RESTRICT_COLLABORATORS],
    delete_collaborator: [OBJECT, RESTRICT_COLLABORATORS],
    create_collaborator: [OBJECT, RESTRICT_COLLABORATORS],
    view_collaborators: [OBJECT, RESTRICT_COLLABORATORS],

    view_attendees: [OBJECT, true],
    view_unpaid_attendees: [OBJECT, true],
    view_cancelled_registrations: [OBJECT, true],
    view_revenue_summary: [OBJECT, true],
    view_packet_printout: [OBJECT, true],
    view_volunteers: [OBJECT, true],
    view_housing: [OBJECT, true],
    view_charts: [OBJECT, true],


  }

  def self.set_for_role(role)
    PERMISSIONS.inject({}) { |h,(k, v)|
      value = v[DEFAULT_ACCESS]
      h[k.to_s] = value.is_a?(Array) ? value[role] : value
      h
    }
  end

  # returns procs or false
  def self.has_procs?(permission)
    permission_data_helper(permission, ACCESS_PROC)
  end

  def self.has_visibility_procs?(permission)
    permission_data_helper(permission, VISIBILITY_PROC)
  end

  def self.should_render?(permission, *args)
    result = true
    proc = self.has_visibility_procs?(permission)

    if proc
      result = proc.call(*args)
    end

    result
  end

  def self.permission_data_helper(permission, position)
    result = false
    data = PERMISSIONS[permission]

    if data && data.length >= (position + 1)
      result = data[position]
    end

    result
  end

  def self.name_for(permission)
    result = permission_data_helper(permission.to_sym, DESCRIPTION)

    if !result
      result = permission.to_s.humanize
    end

    result
  end

  def self.value_for(permission, ownership_status)
    value = PERMISSIONS[permission.to_sym][DEFAULT_ACCESS]
    value.is_a?(Array) ? value[ownership_status] : value
  end

  def self.has_key?(permission)
    PERMISSIONS[permission.to_sym].present?
  end

  def self.is_access?(permission)
    PERMISSIONS[permission][KIND] == ACCESS
  end

  def self.is_object?(permission)
    PERMISSIONS[permission][KIND] == OBJECT
  end

end
