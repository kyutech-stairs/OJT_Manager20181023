class AddUseridToSirabasus < ActiveRecord::Migration[5.2]
  def change
    add_column :sirabasus, :userid, :integer
    add_column :sirabasus, :cid, :integer
  end
end
