module Accounts
  class InvitationsController < Accounts::BaseController
    skip_before_action :authenticate_user!, only: [:accept, :accepted]
    skip_before_action :authorize_user!, only: [:accept, :accepted]
    before_action :authorize_owner!, except: [:accept, :accepted]

    def new
      @invitation = Invitation.new
    end

    def create
      @invitation = current_account.invitations.new(invitation_params)
      @invitation.save

      InvitationEmailJob.perform_later(@invitation.id)
      flash[:notice] = "#{@invitation.email} has been invited."
      redirect_to root_url
    end

    def accept
      store_location_for(:user, request.fullpath)
      @invitation = Invitation.find_by!(token: params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:notice] = "It appears as though that invitation code has already been used."
        redirect_to (root_url subdomain: nil)
    end

    def accepted
      @invitation = Invitation.find_by!(token: params[:id])
      if user_signed_in?
        successful_signup(current_user, @invitation)
      else
        @user = User.new(user_params)
        if @user.save
          successful_signup(@user, @invitation)
        else
          flash[:alert] = "There was an error creating your account."
          redirect_to (accept_invitation_path(@invitation.token, @user))
        end
      end
    end

    private

    def invitation_params
      params.require(:invitation).permit(:email)
    end

    def user_params
      params[:user].permit(:email, :password, :password_confirmation)
    end

    def successful_signup(user, invitation)
      sign_in(user)
      current_account.users << user
      flash[:notice] = "You have joined the #{current_account.name} account."
      redirect_to root_url(subdomain: current_account.subdomain)
      # Make sure the invitation link can't be used again in the future
      invitation.delete
    end
  end
end