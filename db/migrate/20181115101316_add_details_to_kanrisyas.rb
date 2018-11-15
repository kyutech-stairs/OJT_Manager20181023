class AddDetailsToKanrisyas < ActiveRecord::Migration[5.2]
  def change
    add_column :kanrisyas, :image, :string
    add_column :kanrisyas, :check_time, :datetime
  end
end
