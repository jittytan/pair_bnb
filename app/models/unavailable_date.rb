class UnavailableDate < ActiveRecord::Base
	belongs_to :listing
	validates_uniqueness_of :unavailable_date, scope: :listing_id
end
