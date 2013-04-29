class Gutentag::TagNames
  def self.new_with_names(taggable, names)
    tag_names = new(taggable)
    tag_names.clear
    names.each { |name| tag_names << name }
    tag_names
  end

  def initialize(taggable)
    @taggable = taggable
  end

  def to_a
    taggable.tags.collect &:name
  end

  def +(array)
    array.each { |name| self.<< name }
    self
  end

  def <<(name)
    tag = Gutentag::Tag.where(:name => name).first ||
          Gutentag::Tag.create(:name => name)

    taggable.tags << tag
  end

  def clear
    taggable.tags.clear
  end

  private

  attr_reader :taggable
end
