class Gutentag::Persistence

  attr_writer :tagger, :normaliser

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
      taggable.tags << tagger.find_or_create(name)
    end
  end

  def normalised(names)
    names.collect { |name| normaliser.call(name) }.uniq
  end

  def remove_old
    (existing - changes).each do |name|
      taggable.tags.delete tagger.find_by_name(name)
    end
  end

  def tagger
    @tagger ||= Gutentag::Tag
  end

  def normaliser
    @normaliser ||= Proc.new { |name| Gutentag.normaliser.call(name) }
  end
end
