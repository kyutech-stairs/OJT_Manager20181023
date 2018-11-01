class RemoveNameFromChecklists < ActiveRecord::Migration[5.2]
  def change
    remove_column :checklists, :name, :string
  end
end
