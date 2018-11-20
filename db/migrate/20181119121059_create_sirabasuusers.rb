class CreateSirabasuusers < ActiveRecord::Migration[5.2]
  def change
    create_table :sirabasuusers do |t|
      t.integer :kanrisya_id
      t.integer :sirabasu_id
      t.boolean :sirabasu_ok, :boolean, null: false, default: false

      t.timestamps
    end
  end
end
