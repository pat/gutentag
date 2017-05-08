require 'active_support/concern'

module Gutentag::ActiveRecord
  extend ActiveSupport::Concern

  def self.call(model)
    model.has_many :taggings, :class_name => 'Gutentag::Tagging',
      :as => :taggable, :dependent => :destroy
    model.has_many :tags,     :class_name => 'Gutentag::Tag',
      :through => :taggings

    model.after_save :persist_tags

    model.include self
  end

  UNIQUENESS_METHOD = ActiveRecord::VERSION::MAJOR == 3 ? :uniq : :distinct

  module ClassMethods
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

  private

  def persist_tags
    Gutentag::Persistence.new(self).persist
  end
end
