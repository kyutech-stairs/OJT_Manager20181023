class RemoveAuthorFromCrews < ActiveRecord::Migration[5.2]
  def change
    remove_column :crews, :password_confirmation, :string
    remove_column :crews, :password, :string
  end
end
