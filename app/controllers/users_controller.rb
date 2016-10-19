class UsersController < ApplicationController

	def show
		@my_listings = current_user.listings
	end

	def edit
		@user = current_user
	end

	def update
	byebug
		@user = current_user
		@user.update(listing_params)
		redirect_to @user

	end

	private

	def listing_params
		params.require(:user).permit(:first_name, :email, :password)
	end



end
