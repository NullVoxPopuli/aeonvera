class Api::ErrorsController < APIController

  def from_ember
    error = Exceptions::FrontEndError.new(
      message: error_params[:message],
      backtrace: backtrace_as_array
    )

    data = {
      class: error_params[:class],
      method: error_params[:method],
      message: error_params[:message],
      params: error_params[:params]
    }

    PartyFoul::RacklessExceptionHandler.handle(
      error,
      data
    )

    render json:  { error: error_params.to_json }
  end

  private

  def backtrace_as_array
    error_params[:stack].try(:split, "\n") || []
  end

  def error_params
    params[:error].permit(
      :message, :stack,
      :class, :method,
      :cause,
      :params
    )
  end

end
