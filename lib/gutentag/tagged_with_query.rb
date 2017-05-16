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

  def ids?
    options[:ids].present? || options[:tags].present?
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

  def query
    ids? ? id_query : name_query
  end

  def tag_ids
    options[:ids] || Array(options[:tags]).collect(&:id)
  end

  def tag_names
    Array(options[:names]).collect { |tag| Gutentag.normaliser.call(tag) }
  end
end
