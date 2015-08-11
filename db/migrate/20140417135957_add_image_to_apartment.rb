class AddImageToApartment < ActiveRecord::Migration
  def change
    add_column :apartments, :image_url, :string
  end
end
