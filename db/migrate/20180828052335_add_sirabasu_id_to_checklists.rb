class AddSirabasuIdToChecklists < ActiveRecord::Migration[5.2]
  def change
    add_column :checklists, :sirabasu_id, :integer
  end
end
