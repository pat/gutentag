class GutentagCacheCounter < ActiveRecord::Migration
  def up
    add_column :tags, :taggings_count, :integer, default: 0

    add_index :tags, :taggings_count
  end

  def down
    remove_column :tags, :taggings_count
  end
end
