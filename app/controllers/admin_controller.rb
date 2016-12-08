class AdminController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    unless User.admins.any?
      current_user.update_attributes(admin: true)
    end

    unless current_user&.admin?
      error = t('session.invalid_permissions')

      respond_to do |format|
        format.html { redirect_to login_path(next: url_for), flash: {error: error} }
        format.json { render json: {error: error}, status: 401 }
      end

      false
    end
  end
end
