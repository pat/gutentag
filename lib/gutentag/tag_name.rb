class Gutentag::TagName
  def self.call(name)
    new(name).to_s
  end

  def initialize(name)
    @name = name
  end

  def to_s
    name.downcase
  end

  private

  attr_reader :name
end
