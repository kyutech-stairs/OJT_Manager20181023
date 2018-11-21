class AddCsToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :copy, :boolean, null: false, default: false
  end
end
