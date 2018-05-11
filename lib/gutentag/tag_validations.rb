# frozen_string_literal: true

require "active_model/errors"
require "active_record/errors"

class Gutentag::TagValidations
  DEFAULTS = {
    :presence   => true,
    :uniqueness => {:case_sensitive => false}
  }.freeze
  DATABASE_ERROR_CLASSES = lambda {
    classes = []
    if ActiveRecord::VERSION::STRING.to_f > 4.0
      classes << ActiveRecord::NoDatabaseError
    end
    classes << Mysql2::Error     if defined?(::Mysql2)
    classes << PG::ConnectionBad if defined?(::PG)
    classes
  }.call.freeze

  def self.call(klass)
    new(klass).call
  end

  def initialize(klass)
    @klass = klass
  end

  def call
    klass.validates :name, validation_options.dup
  end

  private

  attr_reader :klass

  def add_length_validation?
    klass.table_exists? && limit.present?
  rescue *DATABASE_ERROR_CLASSES
    warn <<-MESSAGE
  The database is not currently available, and so Gutentag was not able to set
  up tag validations completely (in particular: adding a length limit to match
  database constraints).
    MESSAGE
    false
  end

  def limit
    @limit ||= klass.columns_hash["name"].limit
  end

  def validation_options
    return DEFAULTS unless add_length_validation?

    DEFAULTS.merge :length => {:maximum => limit}
  end
end
