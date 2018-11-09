class AddCrewnumberToKanrisyas < ActiveRecord::Migration[5.2]
  def change
    add_column :kanrisyas, :crew_number, :string
  end
end
