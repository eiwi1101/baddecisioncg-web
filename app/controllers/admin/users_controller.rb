class Admin::UsersController < AdminController
  before_action :get_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = filter_scope User.all
    respond_with :admin, @user
  end

  def new
    @user = User.new
    respond_with :admin, @user
  end

  def show; end
  def edit; end

  def create
    @user = User.create(user_params)
    respond_with :admin, @user
  end

  def update
    @user.update_attributes(user_params)
    respond_with :admin, @user
  end

  def destroy
    @user.destroy
    respond_with :admin, @suer
  end

  private

  def get_user
    @user = User.find_by!(guid: params[:id])
  end

  def user_params
    params.require(:user).permit(:display_name, :email, :username, :password, :password_confirmation, :admin)
  end
end
