class Gutentag::TaggedWith::IDQuery < Gutentag::TaggedWith::Query
  private

  def column
    :tag_id
  end

  def join
    :taggings
  end

  def join_model
    Gutentag::Tagging
  end
end
