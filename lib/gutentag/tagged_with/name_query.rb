class Gutentag::TaggedWith::NameQuery < Gutentag::TaggedWith::Query
  def initialize(model, values, match)
    super

    @values = @values.collect { |tag| Gutentag.normaliser.call(tag) }
  end

  private

  def column
    :name
  end

  def join
    :tags
  end

  def join_model
    Gutentag::Tag
  end
end
