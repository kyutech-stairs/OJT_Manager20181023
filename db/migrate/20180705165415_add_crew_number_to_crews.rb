class AddCrewNumberToCrews < ActiveRecord::Migration[5.2]
  def change
    add_column :crews, :crew_number, :string
  end
end
