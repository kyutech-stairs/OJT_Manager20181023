class CreatePublishingConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :publishing_configs do |t|
      t.integer :sirabasu_id
      t.integer :require

      t.timestamps
    end
  end
end
