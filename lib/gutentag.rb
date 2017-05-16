require 'active_record/version'
require 'active_support/deprecation'

module Gutentag
  def self.dirtier
    @dirtier
  end

  def self.dirtier=(dirtier)
    @dirtier = dirtier
  end

  def self.normaliser
    @normaliser ||= lambda { |tag_name| tag_name.to_s.downcase }
  end

  def self.normaliser=(normaliser)
    @normaliser = normaliser
  end

  def self.tag_validations
    @tag_validations ||= Gutentag::TagValidations
  end

  def self.tag_validations=(tag_validations)
    @tag_validations = tag_validations
  end
end

require 'gutentag/active_record'
require 'gutentag/dirty'
require 'gutentag/has_many_tags'
require 'gutentag/persistence'
require 'gutentag/tag_validations'
require 'gutentag/tagged_with_query'

if ActiveRecord::VERSION::MAJOR == 3
  Gutentag.dirtier = Gutentag::Dirty
elsif ActiveRecord::VERSION::MAJOR == 4 && ActiveRecord::VERSION::MINOR < 2
  Gutentag.dirtier = Gutentag::Dirty
end

if defined?(Rails::Engine)
  require 'gutentag/engine'
else
  require 'active_record'
  ActiveRecord::Base.extend Gutentag::HasManyTags
  require_relative '../app/models/gutentag/tag'
  require_relative '../app/models/gutentag/tagging'
end
