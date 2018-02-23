# frozen_string_literal: true

class Gutentag::ActiveRecord
  def self.call(model)
    model.has_many :taggings,
      :class_name => "Gutentag::Tagging",
      :as         => :taggable,
      :dependent  => :destroy
    model.has_many :tags,
      :class_name => "Gutentag::Tag",
      :through    => :taggings

    model.after_save :persist_tags

    model.send :extend, Gutentag::ActiveRecord::ClassMethods

    if ActiveRecord::VERSION::STRING.to_f < 4.2
      model.after_save :reset_tag_names

      model.send :include, Gutentag::ActiveRecord::LegacyInstanceMethods

      model.define_attribute_method "tag_names"
    else
      model.after_commit :reset_tag_names, on: [:create, :update]

      model.send :include, Gutentag::ActiveRecord::ModernInstanceMethods

      model.attribute "tag_names", ActiveRecord::Type::Value.new, :default => []
    end
  end
end

require "gutentag/active_record/class_methods"
require "gutentag/active_record/legacy_instance_methods"
require "gutentag/active_record/modern_instance_methods"
