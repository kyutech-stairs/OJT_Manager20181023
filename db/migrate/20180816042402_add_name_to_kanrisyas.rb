class AddNameToKanrisyas < ActiveRecord::Migration[5.2]
  def change
    add_column :kanrisyas, :name, :string
  end
end
