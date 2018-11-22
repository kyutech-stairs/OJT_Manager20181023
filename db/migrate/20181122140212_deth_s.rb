class DethS < ActiveRecord::Migration[5.2]
  def change
    drop_table :sessions
    drop_table :sessionsses
  end
end
