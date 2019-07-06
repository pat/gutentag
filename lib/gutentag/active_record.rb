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
    if ActiveRecord::VERSION::STRING.to_f <= 4.2
      model.define_attribute_method "tag_names"
    else
      model.attribute "tag_names", ActiveRecord::Type::Value.new,
        :default => default_tag_names
    end
  end

  def add_callbacks
    model.after_save :persist_tags

    if legacy?
      model.after_save :reset_tag_names
    else
      model.after_commit :reset_tag_names, :on => %i[ create update ]
    end
  end

  def add_methods
    case ActiveRecord::VERSION::STRING.to_f
    when 3.2..4.1
      require "gutentag/active_record/instance_methods_3_2"
    when 4.2
      require "gutentag/active_record/instance_methods_4_2"
    else
      require "gutentag/active_record/instance_methods"
    end

    model.send :extend, Gutentag::ActiveRecord::ClassMethods
    model.send :include, Gutentag::ActiveRecord::InstanceMethods
  end

  def default_tag_names
    ActiveRecord::VERSION::STRING.to_f <= 4.2 ? [] : nil
  end

  def legacy?
    ActiveRecord::VERSION::STRING.to_f < 4.2
  end
end

require "gutentag/active_record/class_methods"
