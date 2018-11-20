class AddBelongsToKanrisyas < ActiveRecord::Migration[5.2]
  def change
    add_column :kanrisyas, :belong, :string
  end
end
