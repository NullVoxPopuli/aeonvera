module Authorizable
  extend ActiveSupport::Concern

  included do

    # where the config for this controller is stored
    # after validation
    class_attribute :authorizable_config

    # sets up a before filter that will redirect if the permission
    # condition fails
    #
    # @example
    #  authorizable(
    #    edit: { # implies current_user.can_edit?(@event)
    #      target: :event,
    #      redirect_path: Proc.new{ hosted_event_path(@event) }
    #    }
    #  )
    #
    # @example
    #  authorizable(
    #    create: {
    #      permission: :can_create_event?,
    #      redirect_path: Proc.new{ hosted_events_path }
    #    },
    #    destroy: { # implies current_user.can_delete?(@event)
    #      target: :event,
    #      redirect_path: Proc.new{ hosted_event_path(@event) }
    #    }
    #  )
    #
    # @param [Hash] config the list of options to configure actions to be authorizable
    # @option config [Symbol] action the action to authorize with
    # @option action [ActiveRecord::Base] :user (current_user) object to run the condition on
    # @option action [Symbol] :permission (can_{action}?(target)) the condition to run on the :user
    # @option action [Symbol] :target ("@#{target}") the name of the object passed to the :permission
    #   if no target is provided :permission becomes a required option
    # @option action [Proc] :redirect_path where to go upon unauthorized
    # @option action [String] :message (I18n.t('authorizable.not_authorized'))
    #   message to display as a flash message upon an unauthorized attempt
    # @option action [Symbol] :flash_type (:alert) what flash type to use for displaying the :message
    def self.authorizable(config = {})
      Authorizable.parameters_are_valid?(config)

      self.authorizable_config = config

      self.send(:before_filter, :authorizable_authorized?)
    end
  end

  private

  def authorizable_authorized?
    result = false
    action = params[:action].to_sym

    if !self.class.authorizable_config[action]
      action = Authorizable.alias_action(action)
    end

    settings_for_action = self.class.authorizable_config[action]

    return true unless settings_for_action.present?

    defaults = {
      user: current_user,
      permission: permission_from_action_and_id(action.to_s, params[:id]),
      message: I18n.t('authorizable.not_authorized'),
      flash_type: :alert
    }

    options = defaults.merge(settings_for_action)

    # run permission
    if options[:target]
      object = instance_variable_get("@#{options[:target]}")
      result = options[:user].send(options[:permission], object)
    else
      result = options[:user].send(options[:permission])
    end

    # redirect
    unless result
      authorizable_respond_with(
        options[:flash_type],
        options[:message],
        options[:redirect_path]
      )

      # halt
      return false
    end

    # proceed with execution
    true
  end


  def permission_from_action_and_id(action, id)
    permission = "can_"
    permission << action
    permission << "?"
  end

  def authorizable_respond_with(flash_type, message, path)
    flash[flash_type] = message

    respond_to do |format|
      format.html{
        path = self.instance_eval(&path)
        redirect_to path
      }
      format.json{
        render json: {}, status: 401
      }
    end

  end


  def self.alias_action(action)
    if action == :update
      action = :edit
    elsif action == :edit
      action = :update
    elsif action == :create
      action = :new
    elsif action == :new
      action = :create
    end

    action
  end

  # @see @authorizable for options
  # @return [Boolean]
  def self.parameters_are_valid?(config)
    config.each do |action, settings|
      if !settings[:target]
        # permission is required
        if !settings[:permission]
          raise ArgumentError.new(I18n.t('authorizable.permission_required'))
        end
      end

      # redirect_path is always required
      redirect_path = settings[:redirect_path]
      if !redirect_path
        raise ArgumentError.new(I18n.t('authorizable.redirect_path_required'))
      else
        if !redirect_path.is_a?(Proc)
          raise ArgumentError.new(I18n.t("authorizable.redirect_path_must_be_proc"))
        end
      end
    end
  end

end
