class Accounts::UsersController < Accounts::BaseController
  before_action :authorize_owner!
  protect_from_forgery with: :exception, prepend: true

  def index
  end

  def destroy
    user = User.find(params[:id])
    current_account.users.delete(user)
    flash[:notice] = "#{user.email} has been removed from this account."
    redirect_to users_path
  end
end
