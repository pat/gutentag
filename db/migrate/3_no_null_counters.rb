class NoNullCounters < (ActiveRecord::VERSION::MAJOR == 5 ? ActiveRecord::Migration[5.0] : ActiveRecord::Migration)
  def up
    change_column :gutentag_tags, :taggings_count, :integer, :default => 0,
      :null => false
  end

  def down
    change_column :gutentag_tags, :taggings_count, :integer, :default => 0,
      :null => true
  end
end
