class CreateCheckusers < ActiveRecord::Migration[5.2]
  def change
    create_table :checkusers do |t|
      t.integer :kanrisya_id
      t.integer :checklist_id
      t.boolean :check_ok, :boolean, null: false, default: false

      t.timestamps
    end
  end
end
