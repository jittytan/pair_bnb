class CreateUnavailableDates < ActiveRecord::Migration
  def change
    create_table :unavailable_dates do |t|
    	t.date :unavailable_date
    	t.integer :listing_id
      t.timestamps null: false
    end
  end
end
