class Gutentag::TaggedWith::Query
  def initialize(model, values, match)
    @model  = model
    @values = Array values
    @match  = match
  end

  def call
    model.where "#{model_id} IN (#{query.to_sql})"
  end

  private

  attr_reader :model, :values, :match

  def model_id
    "#{model.quoted_table_name}.#{model.quoted_primary_key}"
  end

  def query
    return taggable_ids_query if match == :any || values.length == 1

    taggable_ids_query.having("COUNT(*) = #{values.length}").group(:taggable_id)
  end
end
