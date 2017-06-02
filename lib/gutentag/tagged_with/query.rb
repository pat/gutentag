class Gutentag::TaggedWith::Query
  UNIQUENESS_METHOD = (ActiveRecord::VERSION::MAJOR == 3 ? :uniq : :distinct)

  def initialize(model, values, match)
    @model  = model
    @values = Array values
    @match  = match
  end

  def call
    if match == :any || values.length == 1
      query.public_send UNIQUENESS_METHOD
    else
      query.having("COUNT(#{model_id}) = #{values.length}").group(model_id)
    end
  end

  private

  attr_reader :model, :values, :match

  def model_id
    "#{model.quoted_table_name}.#{model.quoted_primary_key}"
  end

  def query
    model.joins(join).where(
      join_model.table_name => {column => values}
    )
  end
end
