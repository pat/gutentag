class Gutentag::Tag < ActiveRecord::Base
  has_many :taggings, :class_name => 'Gutentag::Tagging',
    :dependent => :destroy

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}

  before_validation :normalise_name

  def self.find_or_create(name)
    name = Gutentag::TagName.normalise name
    where(:name => name).first || create(:name => name)
  end

  private

  def normalise_name
    self.name = Gutentag::TagName.normalise name
  end
end
