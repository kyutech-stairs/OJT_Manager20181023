class RenameRequireColumnToPublishingConfig < ActiveRecord::Migration[5.2]
  def change
    rename_column :publishing_configs, :require, :required_sirabasu
  end
end
