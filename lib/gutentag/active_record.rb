require 'active_support/concern'

module Gutentag::ActiveRecord
  extend ActiveSupport::Concern

  UNIQUENESS_METHOD = ActiveRecord::VERSION::MAJOR == 3 ? :uniq : :distinct

  module ClassMethods
    def has_many_tags
      has_many :taggings, :class_name => 'Gutentag::Tagging', :as => :taggable,
        :dependent => :destroy
      has_many :tags,     :class_name => 'Gutentag::Tag',
        :through => :taggings

      after_save :persist_tags
    end

    def tagged_with(*options)
      Gutentag::TaggedWithQuery.call self, options.flatten
    end
  end

  def reset_tag_names
    @tag_names = nil
  end

  def tag_names
    @tag_names ||= tags.pluck(:name)
  end

  def tag_names=(names)
    Gutentag.dirtier.call self, names if Gutentag.dirtier

    @tag_names = names
  end

  private

  def persist_tags
    Gutentag::Persistence.new(self).persist
  end
end
