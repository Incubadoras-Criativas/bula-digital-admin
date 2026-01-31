class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  delegate :current_admin, :admin_signed_in?, to: :admin_session

  helper_method :current_admin, :admin_signed_in?

  def admin_session
    AdminSessions.new(session)
  end
end
