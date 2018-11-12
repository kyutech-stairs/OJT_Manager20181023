class AddCheckToKanrisyas < ActiveRecord::Migration[5.2]
  def change
    add_column :kanrisyas, :check, :text, array: true
  end
end
