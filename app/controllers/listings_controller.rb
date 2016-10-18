class ListingsController < ApplicationController

def index
end

def create

	@listing = current_user.listings.new(listing_params)
	@listing.save

	if @listing.save
		redirect_to @listing
	else
		render :new
	end


end

def new
	@listing = Listing.new

	render template:"listings/new"
end

def show
	@listing = Listing.find(params[:id])
end

def index #app/views/listings/index.html.erb

    @listings = Listing.all

end

private

	def listing_params
		params.require(:listing).permit(:name, :description)
	end

end
