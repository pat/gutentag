class NoNullCounters < ActiveRecord::Migration
  def up
    change_column :tags, :taggings_count, :integer, :default => 0,
      :null => false
  end

  def down
    change_column :tags, :taggings_count, :integer, :default => 0,
      :null => true
  end
end
