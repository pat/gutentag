class Gutentag::TagNames
  include Enumerable

  def self.new_with_names(taggable, names)
    tag_names = new(taggable)
    tag_names.clear
    names.each { |name| tag_names << Gutentag::TagName.normalise(name) }
    tag_names
  end

  def initialize(taggable)
    @taggable = taggable
  end

  def to_a
    taggable.tags.collect &:name
  end

  def +(array)
    (normalised(array) - to_a).each { |name| self.<< name }

    self
  end

  def -(array)
    normalised(array).each { |name| self.delete name }

    self
  end

  def <<(name)
    name = Gutentag::TagName.normalise name
    tag  = Gutentag::Tag.where(:name => name).first ||
           Gutentag::Tag.create(:name => name)

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
    taggable.tags.delete Gutentag::Tag.where(:name => name).first
  end

  def each(&block)
    to_a.each &block
  end

  private

  attr_reader :taggable

  def normalised(array)
    array.collect { |name| Gutentag::TagName.normalise(name) }
  end
end
