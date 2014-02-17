module Gutentag
  def self.normaliser
    @normaliser ||= Gutentag::TagName
  end

  def self.normaliser=(normaliser)
    @normaliser = normaliser
  end
end

require 'gutentag/active_record'
require 'gutentag/engine'
require 'gutentag/persistence'
require 'gutentag/tag_name'
