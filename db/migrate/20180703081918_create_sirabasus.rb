class CreateSirabasus < ActiveRecord::Migration[5.2]
  def change
    create_table :sirabasus do |t|
      t.string :name
      t.text :content
      t.integer :number

      t.timestamps
    end
  end
end
