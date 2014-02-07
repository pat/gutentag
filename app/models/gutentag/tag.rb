class Gutentag::Tag < ActiveRecord::Base
  self.table_name = 'gutentag_tags'

  has_many :taggings, :class_name => 'Gutentag::Tagging',
    :dependent => :destroy

  attr_accessible :name if Gutentag.config.attr_accssible?

  scope :by_weight, ->{ order('gutentag_tags.taggings_count DESC') }

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
