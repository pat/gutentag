# frozen_string_literal: true

class Gutentag::Tag < ActiveRecord::Base
  self.table_name = "gutentag_tags"

  has_many :taggings,
    :class_name => "Gutentag::Tagging",
    :dependent  => :destroy

  attr_accessible :name if ActiveRecord::VERSION::MAJOR == 3

  scope :by_weight, lambda { order("gutentag_tags.taggings_count DESC") }

  before_validation :normalise_name

  def self.find_by_name(name)
    where(:name => Gutentag.normaliser.call(name)).first
  end

  def self.find_or_create(name)
    find_by_name(name) || create(:name => name)
  end

  private

  def normalise_name
    self.name = Gutentag.normaliser.call name
  end
end
