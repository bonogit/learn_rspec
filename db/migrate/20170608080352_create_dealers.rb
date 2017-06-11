class CreateDealers < ActiveRecord::Migration
  def change
    create_table :dealers do |t|
      t.string :dealer_unify_id
      t.string :name

      t.timestamps null: false
    end
  end
end
