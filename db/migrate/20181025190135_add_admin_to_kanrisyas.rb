class AddAdminToKanrisyas < ActiveRecord::Migration[5.2]
  def change
    add_column :kanrisyas, :admin, :boolean, null: false, default: false
  end
end
