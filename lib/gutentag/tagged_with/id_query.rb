class Gutentag::TaggedWith::IDQuery < Gutentag::TaggedWith::Query
  private

  def taggable_ids_query
    Gutentag::Tagging.select(:taggable_id).
      where(:taggable_type => model).
      where(:tag_id => values)
  end
end
