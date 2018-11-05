class ApplicationController < ActionController::API

  def render_error(status, errors)
    render json: { errors: errors }, status: status
  end
end
