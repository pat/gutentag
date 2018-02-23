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
    if legacy?
      model.define_attribute_method "tag_names"
    else
      model.attribute "tag_names", ActiveRecord::Type::Value.new, :default => []
    end
  end

  def add_callbacks
    model.after_save :persist_tags

    if legacy?
      model.after_save :reset_tag_names
    else
      model.after_commit :reset_tag_names, on: [:create, :update]
    end
  end

  def add_methods
    model.send :extend, Gutentag::ActiveRecord::ClassMethods

    if legacy?
      model.send :include, Gutentag::ActiveRecord::LegacyInstanceMethods
    else
      model.send :include, Gutentag::ActiveRecord::ModernInstanceMethods
    end
  end

  def legacy?
    ActiveRecord::VERSION::STRING.to_f < 4.2
  end
end

require "gutentag/active_record/class_methods"
require "gutentag/active_record/legacy_instance_methods"
require "gutentag/active_record/modern_instance_methods"
