class UsersController < ApplicationController
  before_action :signed_in_user,   only: [:index, :edit, :update, :destroy]
  before_action :admin_user,   only: [:index, :destroy]

  before_action :correct_user,   only: [:edit, :update]
  before_action :signed_out_user, only: [:create, :new]

	def index
		@users = User.paginate(page: params[:page])
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params)
			flash[:success] = "Your data has been changed!"
			redirect_to @user
		else
			render 'edit'
		end
	end

	def create
		@user = User.new(user_params)
		if @user.save
			flash[:success] = "New user has been created"
			redirect_to root_path
		else
			render 'new'
		end
	end

	def destroy
		user = User.find(params[:id])

		if !current_user?(user)
			user.destroy
			redirect_to users_url
		else
			redirect_to root_url
		end
	end

	private
		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user) || @user.admin?
		end

		def signed_out_user
			redirect_to root_url if signed_in?
		end
end
