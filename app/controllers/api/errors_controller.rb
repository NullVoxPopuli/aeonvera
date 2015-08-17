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
      params: params.merge(from_js: error_params[:params])
    }

    if Rails.env.production?
      PartyFoul::RacklessExceptionHandler.handle(
        error,
        data
      )

      render json:  { error: error_params.to_json }
    else
      # just in case, make sure
      # awesome_print is loaded
      ap data if defined? ap
      render nothing: true, status: 500
    end
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
