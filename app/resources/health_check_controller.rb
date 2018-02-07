class HealthCheckController < ActionController::Metal
  def k8s
    render nothing: true, status: 200
  end
end
