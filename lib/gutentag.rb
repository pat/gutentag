# frozen_string_literal: true

require "active_record/version"

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

require "gutentag/active_record"
require "gutentag/change_state"
require "gutentag/dirty"
require "gutentag/persistence"
require "gutentag/remove_unused"
require "gutentag/tag_names"
require "gutentag/tagged_with"

Gutentag.dirtier = Gutentag::Dirty if ActiveRecord::VERSION::STRING.to_f < 4.2

if defined?(Rails::Engine)
  require "gutentag/engine"
else
  require "active_record"

  Gutentag.autoload :Tag,
    File.expand_path("../app/models/gutentag/tag", __dir__)
  Gutentag.autoload :Tagging,
    File.expand_path("../app/models/gutentag/tagging", __dir__)
end
