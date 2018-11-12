class AddCidsToKanrisyas < ActiveRecord::Migration[5.2]
  def change
    add_column :kanrisyas, :cid, :integer
  end
end
