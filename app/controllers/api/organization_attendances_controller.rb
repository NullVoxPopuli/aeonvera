module Api
  class OrganizationAttendancesController < APIController
    include SkinnyControllers::Diet
    include OrganizationLoader

    self.model_class = OrganizationAttendance

    def index
      @attendances = @organization.attendancens

      render json: @attendances
    end

    def show
      render json: model
    end
  end
end
