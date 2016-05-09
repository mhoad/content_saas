module Accounts
  class WebsitesController < Accounts::BaseController
    before_action :set_website, only: [:show, :edit, :update, :destroy]
    before_action :check_plan_limit, only: [:new, :create]

    def index
      @websites = current_account.websites
    end

    def new
      @website = Website.new
    end

    def create
      @website = current_account.websites.build(website_params)

      if @website.save
        flash[:notice] = "Website has been successfully saved"
        redirect_to website_path(@website.id)
      else
        flash[:alert] = "Website has not been added"
        render "new"
      end
    end

    def show
    end

    def edit
    end

    def update
      if @website.update(website_params)
        flash[:notice] = "Website successfully updated."
        redirect_to website_path(@website.id)
      else
        flash[:alert] = "Unable to edit website."
        render "edit"
      end
    end

    def destroy
      @website = Website.find(params[:id])
      @website.destroy

      flash[:notice] = "Website has been deleted."

      redirect_to websites_path
    end

    private
      def website_params
        params.require(:website).permit(:url)
      end

      def set_website
        @website = current_account.websites.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:alert] = "The website you were looking for cannot be found."
        redirect_to root_url
      end
      
      def check_plan_limit
        if current_account.plan.websites_allowed == current_account.websites.count
          session[:return_to] = request.fullpath
          message = "You have reached your plan's limit."
          message += " You need to upgrade your plan to add more websites."
          flash[:alert] = message
          redirect_to account_choose_plan_path
        end
      end
  end
end