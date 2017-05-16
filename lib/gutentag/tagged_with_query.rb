class Gutentag::TaggedWithQuery
  UNIQUENESS_METHOD = (ActiveRecord::VERSION::MAJOR == 3 ? :uniq : :distinct)

  def self.call(model, tags)
    new(model, tags).call
  end

  def initialize(model, tags)
    @model = model
    @tags  = tags.flatten
  end

  def call
    query.public_send UNIQUENESS_METHOD
  end

  private

  attr_reader :model, :tags

  def ids?
    tags.all? { |tag| tag.is_a? Integer }
  end

  def id_query
    model.joins(:taggings).where(
      Gutentag::Tagging.table_name => {:tag_id => tag_ids}
    )
  end

  def name_query
    model.joins(:tags).where(
      Gutentag::Tag.table_name => {:name => tag_names}
    )
  end

  def objects?
    tags.all? { |tag| tag.is_a? Gutentag::Tag }
  end

  def query
    (ids? || objects?) ? id_query : name_query
  end

  def tag_ids
    return tags if ids?

    tags.collect &:id
  end

  def tag_name(tag)
    Gutentag.normaliser.call(tag.is_a?(Gutentag::Tag) ? tag.name : tag)
  end

  def tag_names
    tags.collect { |tag| tag_name(tag) }
  end
end
