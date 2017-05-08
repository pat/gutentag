require 'active_support/concern'

module Gutentag::ActiveRecord
  extend ActiveSupport::Concern

  UNIQUENESS_METHOD = ActiveRecord::VERSION::MAJOR == 3 ? :uniq : :distinct
  TAG_SEPARATOR = ",".freeze

  module ClassMethods
    def has_many_tags
      has_many :taggings, :class_name => 'Gutentag::Tagging', :as => :taggable,
        :dependent => :destroy
      has_many :tags,     :class_name => 'Gutentag::Tag',
        :through => :taggings

      after_save :persist_tags
    end

    def tagged_with(*tags)
      Gutentag::TaggedWithQuery.call self, tags
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

  def tags_as_string
    tag_names.join(TAG_SEPARATOR)
  end

  def tags_as_string=(s)
    self.tag_names = s.split(TAG_SEPARATOR)
  end

  private

  def persist_tags
    Gutentag::Persistence.new(self).persist
  end
end
