class AddSubsToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :cname_sub, :string
  end
end
