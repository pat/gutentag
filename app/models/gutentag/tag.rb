class Gutentag::Tag < ActiveRecord::Base
  self.table_name = 'gutentag_tags'

  has_many :taggings, :class_name => 'Gutentag::Tagging',
    :dependent => :destroy

  attr_accessible :name if Rails.version.to_s < '4.0.0'

  scope :by_weight, ->{ order('gutentag_tags.taggings_count DESC') }

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
  
  before_validation :normalise_name

  def self.find_by_name(name)
    where(:name => Gutentag.normaliser.call(name)).first
  end

  def self.find_or_create(name)
    find_by_name(name) || create(:name => name)
  end

  private

  def normalise_name
    self.name = Gutentag.normaliser.call name
    generate_slug
  end
  
  def generate_slug
    self.slug = self.name.parameterize
  end
end
