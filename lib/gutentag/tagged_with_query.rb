class Gutentag::TaggedWithQuery
  UNIQUENESS_METHOD = (ActiveRecord::VERSION::MAJOR == 3 ? :uniq : :distinct)

  def self.call(model, options)
    new(model, options).call
  end

  def initialize(model, options)
    @model   = model
    @options = options
  end

  def call
    query.public_send UNIQUENESS_METHOD
  end

  private

  attr_reader :model, :options

  def id_query(ids)
    model.joins(:taggings).where(
      Gutentag::Tagging.table_name => {:tag_id => ids}
    )
  end

  def name_query
    model.joins(:tags).where(
      Gutentag::Tag.table_name => {:name => tag_names}
    )
  end

  def query
    if ids = options[:ids].presence
      id_query(ids)
    elsif tags = options[:tags].presence
      id_query(Array(tags).map(&:id))
    else
      name_query
    end
  end

  def tag_names
    Array(options[:names]).collect { |tag| Gutentag.normaliser.call(tag) }
  end
end
