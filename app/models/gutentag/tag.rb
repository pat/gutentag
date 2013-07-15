class Gutentag::Tag < ActiveRecord::Base
  has_many :taggings, :class_name => 'Gutentag::Tagging',
    :dependent => :destroy

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}

  before_validation :normalise_name

  private

  def normalise_name
    self.name = Gutentag::TagName.normalise name
  end
end
