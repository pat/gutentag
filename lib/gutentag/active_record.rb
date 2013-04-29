require 'active_support/concern'

module Gutentag::ActiveRecord
  extend ActiveSupport::Concern

  module ClassMethods
    def has_many_tags
      has_many :taggings, :class_name => 'Gutentag::Tagging', :as => :taggable,
        :dependent => :destroy
      has_many :tags,     :class_name => 'Gutentag::Tag',
        :through => :taggings
    end
  end

  def tag_names
    @tag_names ||= Gutentag::TagNames.new self
  end

  def tag_names=(names)
    if names.is_a?(Gutentag::TagNames)
      @tag_names = names
    else
      @tag_names = Gutentag::TagNames.new_with_names self, names
    end
  end
end
