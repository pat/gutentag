require 'active_support/concern'

module Gutentag::ActiveRecord
  extend ActiveSupport::Concern

  module ClassMethods
    def has_many_tags
      has_many :taggings, :class_name => 'Gutentag::Tagging', :as => :taggable,
        :dependent => :destroy
      has_many :tags,     :class_name => 'Gutentag::Tag',
        :through => :taggings

      after_save Gutentag::Persistence

      attr_writer :tag_names
    end
  end

  def reset_tag_names
    @tag_names = nil
  end

  def tag_names
    @tag_names ||= tags.collect(&:name)
  end
end
