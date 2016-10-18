class UsersController < ApplicationController

	def show
		@my_listings = current_user.listings
	end
end
