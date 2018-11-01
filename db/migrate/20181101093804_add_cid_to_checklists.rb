class AddCidToChecklists < ActiveRecord::Migration[5.2]
  def change
    add_column :checklists, :cid, :integer
    add_column :checklists, :userid, :integer
  end
end
