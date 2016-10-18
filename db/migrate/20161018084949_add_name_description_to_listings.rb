class AddNameDescriptionToListings < ActiveRecord::Migration
  def change
    add_column :listings, :name, :string
    add_column :listings, :description, :text
  end
end
