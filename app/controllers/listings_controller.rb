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
	@other_listings = Listing.where.not(user_id: current_user.id)
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
	@check_in_date = Date.strptime(params[:listing][:check_in_date], "%d/%m/%Y")
	@amount_of_days = params[:listing][:amount_of_days].to_i
	@check_out_date = @check_in_date + @amount_of_days


	@date_search = (@check_in_date..@check_out_date-1).map do |date|
		date
	end

	@passed_search = []

	@listings.each do |x|
		# @unavailable_dates = x.unavailable_dates.all.map { |a| a.unavailable_date }

		x.unavailable_dates.all.each do |a|
			if @date_search.include?(a.unavailable_date) == true # Thats means the date search contain an unavailable date, which means that listing is not available for the date customer wanted, so failed search
				@failed = true
			end
			break if @failed 
		end

		if @failed == nil # if not failed, that means it passed the loop above and it is available to book for the @date_search given
			@passed_search << x
		# if @date_search.include?(@unavailable_dates) == false 
		# 	@passed_search << x
		end
	end

	render :search
end


	private

	def listing_params
		params.require(:listing).permit(:name, :description, :city, :tag_list, {avatars:[]})
	end

end
