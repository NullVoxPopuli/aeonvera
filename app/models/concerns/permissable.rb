module Permissable
  extend ActiveSupport::Concern

  IS_UNRELATED = 0
  IS_OWNER = 1
  IS_COLLABORATER = 2

  def method_missing(name, *args, &block)
    string_name = name.to_s

    if string_name =~ /can_(.+)\?/
      permission_name = $1
      permission_name.gsub!('destroy', 'delete')
      if ["delete", "edit", "create"].include?(permission_name)
        # shorthand for delete_{object_name}
        object = args[0]
        object_name = object.class.name.downcase
        return send("can_#{permission_name}_#{object_name}?", *args, &block)
      else
        return process_permission(name, permission_name, args)
      end
    else
      super(name, *args, &block)
    end
  end

  private

  def process_permission(method_name, permission_name, args)
    permission = permission_name.to_sym
    o = args[0] # object; Event, Discount, etc
    # default to allow
    result = true

    ownership_status = get_ownership_status_of(o)

    # don't perform the permission evaluation, if we have already computed it
    permission_value_from_cache = value_from_permission_cache(method_name, ownership_status)
    return permission_value_from_cache if permission_value_from_cache.present?


    # evaluate procs
    if (proc = DefaultPermissions.has_procs?(permission))
      result &= proc.call(o, self)
    end

    if ownership_status == IS_COLLABORATER &&
        (o.is_a?(Event) || o.is_a?(Organization))

      collaboration = o.collaborations.where(user_id: self.id).first
      result &= can?(permission, ownership_status, collaboration.permissions)
    else
      result &= can?(permission, ownership_status)
    end

    set_permission_cache(
      name: method_name,
      value: result,
      ownership_status: ownership_status
    )

    result
  end

  # set is a hash of string keys and values
  def can?(permission, ownership_status = IS_OWNER, set = {})
    result = true
    use_default = false

    use_default = true if set[permission.to_s].nil?

    if use_default
      result &= DefaultPermissions.value_for(permission, ownership_status)
    else
      result &= set[permission.to_s]
    end

    result
  end

  def get_ownership_status_of(object)
    if object.is_a?(Event) || object.is_a?(Organization)
      return collaborator_or_owner(object)
    else
      object = (
        if object.respond_to?(:event)
          object.event
        elsif object.respond_to?(:organization)
          object.organization
        end
      )
      return collaborator_or_owner(object)
    end
  end

  # object should only be an Event or Organization
  def collaborator_or_owner(object)
    if object.respond_to?(:user_id)
      if object.user_id == self.id
        return IS_OWNER
      else
        if object.respond_to?(:collaborators)
          if object.collaborator_ids.include?(self.id)
            return IS_COLLABORATER
          end
        end
      end
    end
    # hopefully the object passed always responds to user_id
    IS_UNRELATED
  end

  # calculating the value of a permission is costly.
  # there are several Database lookups and lots of merging
  # of hashes.
  # once a permission is calculated, we'll store it here, so we don't
  # have to re-calculate/query/merge everything all over again
  #
  # for both object access and page access, check if we've
  # already calculated the permission
  #
  # the structure of this cache is the following:
  # {
  #   object_access_permission_name: {
  #     relationship1: true
  #     relationship2: false
  #   },
  #   authorization_permission_name: true
  # }
  def value_from_permission_cache(permission_name, ownership_status = nil)
    @permission_cache ||= {}

    if ownership_status
      @permission_cache[ownership_status] ||= {}
      @permission_cache[ownership_status][permission_name]
    else
      @permission_cache[permission_name]
    end
  end

  def set_permission_cache(name: "", ownership_status: nil, value: nil)
    @permission_cache ||= {}
    if ownership_status
      @permission_cache[ownership_status] ||= {}
      @permission_cache[ownership_status][name] = value
    else
      @permission_cache[name] = value
    end
  end


end
