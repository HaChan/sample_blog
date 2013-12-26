class UsersController < ApplicationController

  before_action :store_location
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
	before_action :already_signed, only: [:new, :create]
	
	def index
		@users = User.paginate(page: params[:page], per_page: 3)
	end
	
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
		@entries = @user.entries.paginate(page: params[:page], per_page: 3)
  end

  def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end
	
	def edit
		@user = User.find(params[:id])
	end
	
	def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render :edit
    end
  end
  
	private
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

		def already_signed
			redirect_to(root_url) if signed_in?
		end

end
