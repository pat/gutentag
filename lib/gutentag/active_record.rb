# frozen_string_literal: true

class Gutentag::ActiveRecord
  def self.call(model)
    new(model).call
  end

  def initialize(model)
    @model = model
  end

  def call
    add_associations
    add_callbacks
    add_methods
    add_attribute
  end

  private

  attr_reader :model

  def add_associations
    model.has_many :taggings,
      :class_name => "Gutentag::Tagging",
      :as         => :taggable,
      :dependent  => :destroy
    model.has_many :tags,
      :class_name => "Gutentag::Tag",
      :through    => :taggings
  end

  def add_attribute
    model.attribute "tag_names", ActiveRecord::Type::Value.new,
      :default => nil
  end

  def add_callbacks
    model.after_save :persist_tags
    model.after_commit :reset_tag_names, :on => %i[ create update ]
  end

  def add_methods
    model.send :extend, Gutentag::ActiveRecord::ClassMethods
    model.send :include, Gutentag::ActiveRecord::InstanceMethods
  end
end

require "gutentag/active_record/class_methods"
require "gutentag/active_record/instance_methods"
