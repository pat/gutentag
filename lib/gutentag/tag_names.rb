class Gutentag::TagNames
  include Enumerable

  def self.new_with_names(taggable, names)
    new(taggable).replace names
  end

  def initialize(taggable)
    @taggable = taggable
  end

  def to_a
    taggable.tags.collect &:name
  end

  def +(array)
    normalised(array).each { |name| self.<< name }

    self
  end

  def -(array)
    normalised(array).each { |name| self.delete name }

    self
  end

  def <<(name)
    tag = Gutentag::Tag.find_or_create name

    taggable.tags << tag unless taggable.tags.include?(tag)
  end

  def |(array)
    to_a | normalised(array)
  end

  def &(array)
    to_a & normalised(array)
  end

  def clear
    taggable.tags.clear
  end

  def delete(name)
    taggable.tags.delete Gutentag::Tag.find_by_name(name)
  end

  def each(&block)
    to_a.each &block
  end

  def replace(names)
    clear
    self.+ names
  end

  private

  attr_reader :taggable

  def normalised(array)
    array.collect { |name| Gutentag::TagName.normalise(name) }
  end
end
