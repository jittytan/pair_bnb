class Listing < ActiveRecord::Base
	belongs_to :user
	has_many :taggings, dependent: :destroy
	has_many :tags, through: :taggings
  has_many :unavailable_dates
  has_many :reservations
  mount_uploaders :avatars, AvatarUploader
  searchkick match: :word_start, searchable: [:name, :city], suggest: [:city]


def self.tagged_with(name)
	Tag.find_by_name!(name).articles
end

def self.tag_counts
  Tag.select("tags.*, count(taggings.tag_id) as count").
    joins(:taggings).group("taggings.tag_id")
end

def tag_list
  tags.map(&:name).join(", ")
end

def tag_list=(names)
  self.tags = names.split(",").map do |n|
    Tag.where(name: n.strip).first_or_create!
  end
end

end
