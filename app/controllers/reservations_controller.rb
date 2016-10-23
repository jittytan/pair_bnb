class ReservationsController < ApplicationController
  def new
  	@listing = Listing.find(params[:listing_id])
  	@reservation = Reservation.new
  end

  def create

  	@listing = Listing.find(params[:listing_id])
		@check_in_date = Date.parse(params[:reservation][:check_in_date])
  	@check_out_date = @check_in_date + params[:reservation][:amount_of_days].to_i
  	(@check_in_date..@check_out_date-1).each do |date|
  		@unavailable_date = UnavailableDate.new(unavailable_date: (date.strftime('%d/%m/%Y')), listing_id:params[:listing_id]) 
  		@unavailable_date.save
  			if @unavailable_date.save
  			else
  				@flash = @unavailable_date.errors.full_messages
  			end
  	end


  	if @flash == nil

	  	@reservation = current_user.reservations.new(listing_id: params[:listing_id], check_in_date: params[:reservation][:check_in_date], amount_of_days: params[:reservation][:amount_of_days].to_i)
	  	@reservation.save
	  	redirect_to (listing_reservation_path(listing_id: params[:listing_id], id: @reservation.id))
	  else
	  	@flash = @unavailable_date.errors.full_messages
	  	@reservation = Reservation.new
	  	render :new
	  end

  end

  def show

  	@listing = Listing.find(params[:listing_id])
  	@reservation = Reservation.find(params[:id])
  	@check_out_date = (Date.parse(@reservation.check_in_date) + @reservation.amount_of_days.to_i).strftime('%d/%m/%Y')

  end

  def index
		@reservations = Reservation.where(user_id: params[:id])
  end
end
