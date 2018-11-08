class AddPasswordToCrews < ActiveRecord::Migration[5.2]
  def change
    add_column :crews, :password_digest, :string
  end
end
