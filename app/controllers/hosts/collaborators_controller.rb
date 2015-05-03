class Hosts::CollaboratorsController < ApplicationController
  include SetsHost

  skip_before_filter :sets_host, only: [:accept]
  skip_before_filter :authenticate_user!, only: [:accept]

  before_filter :authorized?, only: [:accept]
  before_filter :set_host, only: [:accept]

  #before_action :set_event, except: [:accept]
  before_action :fix_permission_values, only: [:update]
  before_action :create_decorator

  def index
    @collaborators = @host.collaborators.all
  end

  def new
    # render form for filling out email and maybe a message
  end

  def edit
    if current_user.can_edit_collaborator?(@host)
      @collaboration = @host.collaborations.where(user_id: params[:id]).first
      @user = @collaboration.user
    else
      flash[:error] = "You do not have permission to edit collaborators"
    end
  end

  def update
    if current_user.can_edit_collaborator?(@host)
      @collaboration = @host.collaborations.find(params[:id])
      if @collaboration.update(collaboration_params)
        flash[:notice] = "Collaborator successfully updated"
      end
    end

    flash[:notice] = "Collaborator could not be updated" if flash[:notice].empty?
    redirect_to action: :index
  end

  def destroy
    if current_user.can_delete_collaborator?(@host)
      collaborations = @host.collaborations.where(user_id: params[:id])

      if collaborations
        if collaborations.destroy_all
          flash[:notice] = "Collaborator removed"
        end
      end
    end

    flash[:notice] = "Collaborator could not be removed" if flash[:notice].empty?
    redirect_to action: :index
  end

  def accept
    # look up token
    key = "#{@host.class.name}-#{@host.id}-#{params[:token]}"
    if Cache.get(key) and Cache.get("#{key}-email") == current_user.email

      # make sure this person is not already a collaborator
      # and that the current_uer is not the owner of the
      # event or organization
      if (not @host.collaborators.include?(current_user)) && @host.hosted_by != current_user
        # push the user in to the collaborators list
        @host.collaborators << current_user
        flash[:notice] = "You are now helping with this #{@host.class.name}"
      else
        flash[:notice] = "You are already helping with this #{@host.class.name}"
      end

      # reduce cache bloat
      Cache.delete(key)
      Cache.delete("#{key}-email")

      # redirect to the event the person was just added to
      path = hosted_event_path(@host.id)
      path = organization_path(@host.id) if @host.is_a?(Organization)

      return redirect_to path
    else
      flash[:notice] = "Key not found or your user is not associated with the invited email"
    end

    redirect_to root_path
  end

  def invite
    if @host.collaborators.map(&:email).include?(params[:email])
      flash[:notice] = "This person is already a collaborator"
      return
    end

    # generate token based off email
    token = Digest::SHA1.hexdigest(params[:email] + Time.now.to_s)

    # store the token in the cache so that it can be looked up later
    # by the person receiving the email
    key = "#{@host.class.name}-#{@host.id}-#{token}"
    Cache.set(key, true)
    Cache.set("#{key}-email", params[:email])

    # choose correct path
    accept_link_options = [@host, token: token, from_email: true]
    path = accept_hosted_event_collaborators_url(*accept_link_options)
    if @host.is_a?(Organization)
      path = accept_organization_collaborators_url(*accept_link_options)
    end

    # send an email to the provided email
    CollaboratorsMailer.invitation(
      from: current_user, email_to: params[:email],
      host: @host, link: path
    ).deliver!
  end

  private

  def authorized?
    if not current_user.present?
      cookies[:return_path] = request.fullpath
      flash[:error] = "You must be logged in to accept invitations."
      redirect_to action: "index"
    end
  end

  def set_host
    if params[:controller].include?("events")
      # event collaboration
      @host = Event.find(params[:hosted_event_id])
    else
      # organization collaboration
      @host = Organization.find(params[:organization_id])
    end
  end

  def collaboration_params
    params[:collaboration].permit(
      :title,
      permissions: DefaultPermissions::PERMISSIONS.keys
    )
  end

  # rails sends "1" and "0" for its checkbox fields, and
  # won't automatically convert those to booleans unless
  # they key maps to a boolean column on the corresponding
  # object's table
  def fix_permission_values
    if collaboration = params[:collaboration]
      if permissions = collaboration[:permissions]
        boolean_permissions = permissions.inject({}){ |h, (k,v)|
          h[k] = v.to_b
          h
        }
        collaboration[:permissions] = boolean_permissions
      end
    end
  end

  def create_decorator
    @decorator = HostDecorator.new(@host)
  end

end
