class HostDecorator < Draper::Decorator

  def underscored_name
    if object.is_a? Event
      "hosted_event"
    elsif object.is_a? Organization
      Organization.name.downcase
    end
  end

  def edit_collaborator_path(id)
    h.send("edit_#{underscored_name}_collaborator_path", object, id)
  end

  def collaborator_update_path(id)
    h.send("#{underscored_name}_collaborator_path", object, id)
  end

  def collaborators_path
    h.send("#{underscored_name}_collaborators_path", object)
  end

  def invite_collaborator_path
    h.send("invite_#{underscored_name}_collaborators_path", object)
  end
end
