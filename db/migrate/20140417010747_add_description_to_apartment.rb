class AddDescriptionToApartment < ActiveRecord::Migration
  def change
    add_column :apartments, :description, :string
  end
end
