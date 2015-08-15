class Exceptions::FrontEndError

  # fake exception, because we don't want the execution of code to
  # halt when this class is created
  def initialize(message: '', backtrace: [])
    @message = message
    @backtrace = backtrace
  end


  # should be an array of each line in the trace
  def backtrace
    @backtrace
  end

  # description of what happened
  def message
    @message
  end
end
