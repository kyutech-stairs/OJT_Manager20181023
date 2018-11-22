class AddPasToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :pas, :integer
  end
end
