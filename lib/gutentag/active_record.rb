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

    def tagged_with(*arguments)
      arguments.flatten!

      case arguments.first
      when Hash
        Gutentag::TaggedWithQuery.call(self, arguments.first)
      when Integer
        Rails.logger.warn "Calling tagged_with with an array of integers is deprecated, and will not be supported in Gutentag 1.0. Please use tagged_with :ids => [1, 2] instead."
        Gutentag::TaggedWithQuery.call(self, :ids => arguments)
      when Gutentag::Tag
        Rails.logger.warn "Calling tagged_with with an array of tags is deprecated, and will not be supported in Gutentag 1.0. Please use tagged_with :tags => [tag_a, tag_b] instead."
        Gutentag::TaggedWithQuery.call(self, :tags => arguments)
      else
        Rails.logger.warn "Calling tagged_with with an array of strings is deprecated, and will not be supported in Gutentag 1.0. Please use tagged_with :names => [\"melbourne\", \"ruby\"] instead."
        Gutentag::TaggedWithQuery.call(self, :names => arguments)
      end
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
