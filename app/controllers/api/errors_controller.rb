class Api::ErrorsController < APIController

  def from_ember
    # binding.pry
    error = Exceptions::FrontEndError.new
    data = {
      class: '',
      method: '',
      message: ''
    }
    PartyFoul::RacklessExceptionHandler.handle(
      error,
      data
    )
  end

end
