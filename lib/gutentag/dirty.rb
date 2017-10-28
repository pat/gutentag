# frozen_string_literal: true

class Gutentag::Dirty
  def self.call(instance, tag_names)
    new(instance, tag_names).call
  end

  def initialize(instance, tag_names)
    @instance, @tag_names = instance, tag_names
  end

  def call
    instance.changed_attributes[:tag_names] = existing if changes.present?
  end

  private

  attr_reader :instance, :tag_names

  def changes
    (existing + tag_names).uniq - (existing & tag_names)
  end

  def existing
    instance.tag_names
  end
end
