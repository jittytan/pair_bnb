class ReservationJob < ActiveJob::Base
  queue_as :default

  def perform(cust, host, listing_id, reservation_id)
    ReservationMailer.notification_email(cust, host, listing_id, reservation_id).deliver_now
  end
end
