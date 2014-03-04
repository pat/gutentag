require 'active_support/concern'

module Gutentag::ActiveRecord
  extend ActiveSupport::Concern

  module ClassMethods
    def has_many_tags
      has_many :taggings, :class_name => 'Gutentag::Tagging', :as => :taggable,
        :dependent => :destroy
      has_many :tags,     :class_name => 'Gutentag::Tag',
        :through => :taggings

      after_save { |instance| Gutentag::Persistence.new(instance).persist  }
    end
  end

  def reset_tag_names
    @tag_names = nil
  end

  def tag_names
    @tag_names ||= tags.collect(&:name)
  end

  def tag_names=(names)
    existing = _denormalised(tag_names) || []
    new = _denormalised(names) || []
    changes = (existing + new).uniq - (existing & new)
    changed_attributes[:tag_names] = tag_names if changes.present?
    @tag_names = names
  end

  private
  def _denormalised(names)
    names.split(",").flatten rescue names
  end
end
