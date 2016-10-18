class Tag < ActiveRecord::Base
	has_many :taggings
	has_many :listings, through: :taggings
	# it is many-to many relationship
	# listing has many tags and tag has many listings
	# so tagging is the middle table to connect the listings
	
end
