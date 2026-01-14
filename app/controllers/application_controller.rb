class ApplicationController < ActionController::API
  private

  def current_user
    return @current_user if defined?(@current_user)

    raw = request.headers['X-User-Id']

    return @current_user = nil if raw.blank?
    return @current_user = nil if !raw.to_s.match?(/\A\d+\z/)

    @current_user = User.find_by(id: raw.to_i)
  end

  def authenticate_user!
    return if current_user.present?

    render json: { error: 'Unauthorized'}, status: :unauthorized if current_user.nil?
  end
end
