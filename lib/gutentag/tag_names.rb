class Gutentag::TagNames
  def self.call(*names)
    new(names).call
  end

  def initialize(names)
    @names = names.flatten
  end

  def call
    name_values.collect { |name| Gutentag::TagName.call name }
  end

  private

  attr_reader :names

  def name_values
    names.collect { |name| name.respond_to?(:name) ? name.name : name.to_s }
  end
end
