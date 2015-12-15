class Api::UsersController < APIController

  before_filter :must_be_logged_in, except: :create

  def show
    # this should never return any other user
    # there is no multi-user management.
    render json: current_user
  end

  # Signing up for an account
  def create
    user = User.new(user_params)

    if user.save
      render json: user, status: :created
    else
      render json: user
    end
  end


  # updating profile information
  def update
    update_params = user_params.merge(
      current_password: params[:user].try(:[], :current_password)
    )

    current_user.update_with_password(update_params)
    render json: current_user
  end


  # Deleting the account
  # this isn't permanent / just sets deleted at, and then prevents login.
  # TODO: add a form to re-activate the account / user
  def destroy
    if current_user
      # TODO: maybe provide a link to the registered events
      # so that they can cancel if they *really* want to cancel their account.
      # alternatively, just change the wording to 'deactivate', and change the
      # relationship to the user to include deleted_at
      if current_user.upcoming_events.count > 0
        current_user.errors.add(
          :base,
          "You cannot delete your account when you are about to attend an event. You will first have to cancel all your attendances"
        )
      else
        current_user.destroy
      end

      if current_user.errors.full_messages.present?
        render json: current_user
      else
        render json: current_user, status: :success
      end
    else
      render nothing: true, status: :success
    end
  end



  private

  def user_params
    params[:user].permit(
      :first_name, :last_name,
      :email,
      :password,
      :password_confirmation,
      :time_zone
      # don't worry about null / '' fields
      # all fields on a user are required,
      # yet the password fields are optional
    ).select{ |k, v| v.present? }
  end

end
