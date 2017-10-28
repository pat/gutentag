# frozen_string_literal: true

class Gutentag::ActiveRecord
  def self.call(model)
    model.has_many :taggings, :class_name => "Gutentag::Tagging",
      :as => :taggable, :dependent => :destroy
    model.has_many :tags,     :class_name => "Gutentag::Tag",
      :through => :taggings

    model.after_save :persist_tags

    model.send :extend,  Gutentag::ActiveRecord::ClassMethods
    model.send :include, Gutentag::ActiveRecord::InstanceMethods
  end
end

require "gutentag/active_record/class_methods"
require "gutentag/active_record/instance_methods"
