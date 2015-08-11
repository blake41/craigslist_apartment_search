class CreateApartments < ActiveRecord::Migration
  def change
    create_table :apartments do |t|
      t.string :href
      t.integer :price
      t.string :location
      t.integer :bedrooms

      t.timestamps
    end
  end
end
