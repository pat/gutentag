require 'active_support/concern'

module Gutentag::ActiveRecord
  extend ActiveSupport::Concern

  module ClassMethods
    def has_many_tags
      has_many :taggings, :class_name => 'Gutentag::Tagging', :as => :taggable
      has_many :tags,     :class_name => 'Gutentag::Tag',
        :through => :taggings
    end
  end
end
