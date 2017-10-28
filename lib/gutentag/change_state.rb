class Gutentag::ChangeState
  attr_reader :taggable
  attr_writer :normaliser

  def initialize(taggable)
    @taggable = taggable
    @existing = normalised taggable.tags.collect(&:name)
    @changes  = normalised taggable.tag_names
  end

  def added
    @added ||= changes - existing
  end

  def removed
    @removed ||= existing - changes
  end

  private

  attr_reader :existing, :changes

  def normalised(names)
    names.collect { |name| normaliser.call(name) }.uniq
  end

  def normaliser
    @normaliser ||= Proc.new { |name| Gutentag.normaliser.call(name) }
  end
end
