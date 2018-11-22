class DethCrew < ActiveRecord::Migration[5.2]
  def change
    drop_table :crews
  end
end
