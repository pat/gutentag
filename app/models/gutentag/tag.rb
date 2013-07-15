class Gutentag::Tag < ActiveRecord::Base
  has_many :taggings, :class_name => 'Gutentag::Tagging',
    :dependent => :destroy

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
end
