class AddImageToCrews < ActiveRecord::Migration[5.2]
  def change
    add_column :crews, :image, :string
  end
end
