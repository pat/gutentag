class Gutentag::Tag < ActiveRecord::Base
  has_many :taggings, :class_name => 'Gutentag::Tagging',
    :dependent => :destroy
end
