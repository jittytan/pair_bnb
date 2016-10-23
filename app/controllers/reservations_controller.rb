class ReservationsController < ApplicationController
  def new
  	@listing = Listing.find(params[:listing_id])
  	@reservation = Reservation.new
  end

  def create

  	@listing = Listing.find(params[:listing_id])
		@check_in_date = Date.strptime(params[:reservation][:check_in_date], "%m/%d/%Y")

		if @check_in_date > Date.today && @check_in_date < 6.months.since
	  	@check_out_date = @check_in_date + params[:reservation][:amount_of_days].to_i
	  	@number_saved = 0
	  	(@check_in_date..@check_out_date-1).each do |date| # imagine if stay one day, the unavailable date will be the checking-in day itself, next day will be chackout but the checkout date is allow for reservation, therefore I minus out the check_out date
	  		@unavailable_date = UnavailableDate.new(unavailable_date: date, listing_id:params[:listing_id]) 
	  		@unavailable_date.save
	  			if @unavailable_date.save
	  				@number_saved += 1
	  			else
	  				UnavailableDate.order('created_at DESC').limit(@number_saved).destroy_all # because other date is/are already save before hitting the unavailable date, so need to delete the already saved date 
	  				@flash_msg = "The date that you have chosen is not available!"
	  			end

	  		break if @flash_msg
	  	end


	  	if @flash_msg == nil

		  	@reservation = current_user.reservations.new(listing_id: params[:listing_id], check_in_date: @check_in_date, amount_of_days: params[:reservation][:amount_of_days].to_i)
		  	@reservation.save
		  	redirect_to (listing_reservation_path(listing_id: params[:listing_id], id: @reservation.id))
		  else
		  	@reservation = Reservation.new
		  	render :new
		  end


		elsif @check_in_date <= Date.today
			@flash_msg = "Please do not pick today or out-dated dates!"
			@reservation = Reservation.new
		 	render:new

		else

			@flash_msg = "Please choose date that is within 6 months from now!"
			@reservation = Reservation.new
		 	render:new
		end

  end

  def show

  	@listing = Listing.find(params[:listing_id])
  	@reservation = Reservation.find(params[:id])
  	@check_in_date = (@reservation.check_in_date).strftime("%A %d %B %Y")
  	@check_out_date = (@reservation.check_in_date + @reservation.amount_of_days.to_i).strftime("%A %d %B %Y")


  end

  def index
		@reservations = Reservation.where(user_id: params[:id])
  end
end
