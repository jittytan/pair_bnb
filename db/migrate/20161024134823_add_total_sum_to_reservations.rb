class AddTotalSumToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :total_sum, :integer
  end
end
