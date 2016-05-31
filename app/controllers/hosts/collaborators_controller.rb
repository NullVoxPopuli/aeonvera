class Hosts::CollaboratorsController < ApplicationController
  include SetsHost

  skip_before_filter :sets_host, only: [:accept]
  skip_before_filter :authenticate_user!, only: [:accept]

  before_filter :authorized?, only: [:accept]
  before_filter :set_host, only: [:accept]

  #before_action :set_event, except: [:accept]
  before_action :fix_permission_values, only: [:update]
  before_action :create_decorator

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


  private

end
