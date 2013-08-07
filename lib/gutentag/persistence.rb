class Gutentag::Persistence
  def self.after_save(taggable)
    new(taggable).persist
  end

  def initialize(taggable)
    @taggable = taggable
    @existing = normalised taggable.tags.collect(&:name)
    @changes  = normalised taggable.tag_names
  end

  def persist
    remove_old
    add_new

    taggable.reset_tag_names
  end

  private

  attr_reader :taggable, :existing, :changes

  def add_new
    (changes - existing).each do |name|
      taggable.tags << Gutentag::Tag.find_or_create(name)
    end
  end

  def normalised(names)
    names.collect { |name| Gutentag::TagName.normalise(name) }.uniq
  end

  def remove_old
    (existing - changes).each do |name|
      taggable.tags.delete Gutentag::Tag.find_by_name(name)
    end
  end
end
