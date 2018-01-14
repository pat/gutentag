# frozen_string_literal: true

class Gutentag::RemoveUnused
  def self.call
    Gutentag::Tag.connection.execute <<-SQL
  DELETE FROM gutentag_tags
  WHERE id NOT IN (SELECT DISTINCT tag_id FROM gutentag_taggings)
    SQL
  end
end
