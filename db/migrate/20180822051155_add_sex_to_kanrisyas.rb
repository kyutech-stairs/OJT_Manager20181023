class AddSexToKanrisyas < ActiveRecord::Migration[5.2]
  def change
    add_column :kanrisyas, :sex, :string
  end
end
