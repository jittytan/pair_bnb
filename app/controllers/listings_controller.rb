class ListingsController < ApplicationController

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

def tag
	@listings = Tag.find(params[:id]).listings
	render :index
end


def index #app/views/listings/index.html.erb
  @listings = Listing.all
end

def edit
	@listing = Listing.find(params[:id])
end

def update
	@listing = Listing.find(params[:id])
	@listing.update(listing_params)
	if @listing.save 
    redirect_to @listing 
  else 
    render :edit 
	end
end

def destroy
	@listing = Listing.find(params[:id])
	@listing.destroy
	redirect_to user_path
end


def search

	@listings = Listing.where(city: params[:listing][:city])

	render :index
end


	private

	def listing_params
		params.require(:listing).permit(:name, :description, :city, :tag_list, {avatars:[]})
	end

end
