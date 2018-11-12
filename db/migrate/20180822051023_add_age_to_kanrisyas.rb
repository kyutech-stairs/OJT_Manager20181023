class AddAgeToKanrisyas < ActiveRecord::Migration[5.2]
  def change
    add_column :kanrisyas, :age, :integer
  end
end
