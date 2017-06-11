class AddFulfillDateToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :fulfill_date, :date
  end
end
