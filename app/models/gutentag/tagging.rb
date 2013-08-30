class Gutentag::Tagging < ActiveRecord::Base
  belongs_to :taggable, :polymorphic => true
  belongs_to :tag, :class_name => 'Gutentag::Tag', :counter_cache => true

  validates :taggable, :presence => true
  validates :tag,      :presence => true
  validates :tag_id,   :uniqueness => {
    :scope => [:taggable_id, :taggable_type]
  }
end
