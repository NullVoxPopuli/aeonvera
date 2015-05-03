class RouteRecognizer
  include Singleton

  ROUTE_LIST = Rails.application.routes.routes.collect{|r| r.path.spec.to_s}
  REGEX_ROUT_LIST = ROUTE_LIST.map{|r|
    Regexp.new(r.gsub(/\:(.*)id/, "(\d+)").gsub("(.:format)", ""))
  }

  def self.is_route?(path)
    REGEX_ROUT_LIST.each do |regex|
      return true if !!(path =~ regex)
    end
    false
  end
end
