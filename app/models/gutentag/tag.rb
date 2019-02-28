# frozen_string_literal: true

class Gutentag::Tag < ActiveRecord::Base
  self.table_name = "gutentag_tags"

  has_many :taggings,
    :class_name => "Gutentag::Tagging",
    :dependent  => :destroy

  attr_accessible :name if ActiveRecord::VERSION::MAJOR == 3

  scope :by_weight, lambda { order("gutentag_tags.taggings_count DESC") }

  def self.find_by_name(name)
    where(:name => Gutentag.normaliser.call(name)).first
  end

  def self.find_or_create(name)
    find_by_name(name) || create(:name => name)
  end

  def self.names_for_scope(scope)
    join_conditions = {:taggable_type => scope.name}
    if scope.current_scope.present?
      join_conditions[:taggable_id] = scope.select(:id)
    end

    joins(:taggings).where(
      Gutentag::Tagging.table_name => join_conditions
    ).distinct.pluck(:name)
  end

  def name=(value)
    super(Gutentag.normaliser.call(value))
  end
end

require "gutentag/tag_validations"
Gutentag.tag_validations.call Gutentag::Tag
