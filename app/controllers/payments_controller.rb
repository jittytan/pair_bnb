class PaymentsController < ApplicationController
  def new
  	@client_token = Braintree::ClientToken.generate
    @listing = Listing.find(params[:listing_id])
    @reservation = Reservation.find(params[:reservation_id])
    @reservation_id = params[:reservation_id]
    @check_in_date = @reservation.check_in_date.strftime("%A %d %B %Y")
    @check_out_date = (@reservation.check_in_date + @reservation.amount_of_days.to_i).strftime("%A %d %B %Y")
    @payment = Payment.new
  end

  def create
  	amount = params[:payment][:total_price]
    nonce = params[:payment_method_nonce]

    render action: :new and return unless nonce

    @result = Braintree::Transaction.sale(
      amount: amount,
      payment_method_nonce: params[:payment_method_nonce]
    )

    if @result.success?
      Payment.create(reservation_id: params[:payment][:reservation_id], braintree_payment_id: @result.transaction.id, status: @result.transaction.status, fourdigit: @result.transaction.credit_card_details.last_4)

        redirect_to listing_reservation_path(:id => params[:payment][:reservation_id], :listing_id => params[:listing_id]), notice: "Congratulations! Your transaction is successful!"
    else
        Payment.create(reservation_id: params[:payment][:reservation_id], braintree_transaction_id: @result.transaction.id, status: @result.transaction.status, fourdigit: @result.transaction.credit_card_details.last_4)
        flash[:alert] = "Something went wrong while processing your transaction. Please try again!"
        @client_token = Braintree::ClientToken.generate
        @reservation = Reservation.find(params[:payment][:reservation_id])
        @payment = Payment.new
        render :new
    end
  end
end
