class RenameDeliveryDateToExpectDeliveryDate < ActiveRecord::Migration
  def change
  	rename_column :orders, :delivery_date, :expect_delivery_date
  end
end
