class AddImagesToSirabasus < ActiveRecord::Migration[5.2]
  def change
    add_column :sirabasus, :image, :json
  end
end
