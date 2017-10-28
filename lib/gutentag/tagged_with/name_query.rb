# frozen_string_literal: true

class Gutentag::TaggedWith::NameQuery < Gutentag::TaggedWith::Query
  def initialize(model, values, match)
    super

    @values = @values.collect { |tag| Gutentag.normaliser.call(tag) }
  end

  private

  def taggable_ids_query
    Gutentag::Tagging.joins(:tag).select(:taggable_id).
      where(:taggable_type => model.name).
      where(Gutentag::Tag.table_name => {:name => values})
  end
end
