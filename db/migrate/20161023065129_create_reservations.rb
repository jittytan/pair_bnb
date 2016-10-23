class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :user_id
      t.integer :listing_id
      t.string :check_in_date
      t.integer :amount_of_days

      t.timestamps null: false
    end
  end
end
