require 'active_record/version'

module Gutentag
  def self.dirtier
    @dirtier
  end

  def self.dirtier=(dirtier)
    @dirtier = dirtier
  end

  def self.normaliser
    @normaliser ||= Gutentag::TagName
  end

  def self.normaliser=(normaliser)
    @normaliser = normaliser
  end
end

require 'gutentag/active_record'
require 'gutentag/dirty'
require 'gutentag/engine'
require 'gutentag/persistence'
require 'gutentag/tag_name'

if ActiveRecord::VERSION::MAJOR == 3
  Gutentag.dirtier = Gutentag::Dirty
elsif ActiveRecord::VERSION::MAJOR == 4 && ActiveRecord::VERSION::MINOR < 2
  Gutentag.dirtier = Gutentag::Dirty
end
