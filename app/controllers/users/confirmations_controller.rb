class Users::ConfirmationsController < ApplicationController
  respond_to :html, :json

  skip_before_filter :authenticate_user!
  skip_before_filter :authenticate_user_from_token!

  def show
    binding.pry
    self.resource = User.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      redirect_to 'marketing#index'
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end
end
