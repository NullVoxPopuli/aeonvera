module AttendanceHelper

  def list_of_shirts_for(attendance)
    attendance.shirts.map{ |shirt|
      "#{shirt.name}: #{shirt.size}"
    }.join(', ')
  end

end
