class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :dealer, index: true, foreign_key: true
      t.date :delivery_date
      t.string :status, default: 'ordered'

      t.timestamps null: false
    end
  end
end
