class GutentagTables < ActiveRecord::Migration
  def up
    create_table :taggings do |t|
      t.integer :tag_id,        :null => false
      t.integer :taggable_id,   :null => false
      t.string  :taggable_type, :null => false
      t.timestamps
    end

    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_type, :taggable_id]
    add_index :taggings, [:taggable_type, :taggable_id, :tag_id],
      :unique => true, :name => 'unique_taggings'

    create_table :tags do |t|
      t.string :name, :null => false
      t.timestamps
    end

    add_index :tags, :name, :unique => true
  end

  def down
    drop_table :tags
    drop_table :taggings
  end
end
