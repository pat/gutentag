class Gutentag::Tag < ActiveRecord::Base
  has_many :taggings, :class_name => 'Gutentag::Tagging',
    :dependent => :destroy

  attr_accessible :name if Rails.version.to_s < '4.0.0'

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}

  before_validation :normalise_name

  def self.find_by_name(name)
    where(:name => Gutentag::TagName.normalise(name)).first
  end

  def self.find_or_create(name)
    find_by_name(name) || create(:name => name)
  end

  private

  def normalise_name
    self.name = Gutentag::TagName.normalise name
  end
end
