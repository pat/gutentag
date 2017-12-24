# frozen_string_literal: true

class Gutentag::TagValidations
  def self.call(klass)
    new(klass).call
  end

  def initialize(klass)
    @klass = klass
  end

  def call
    klass.validates :name,
      :presence   => true,
      :uniqueness => {:case_sensitive => false}

    klass.validates_length_of :name, :maximum => limit if add_length_validation?
  end

  private

  attr_reader :klass

  def add_length_validation?
    klass.table_exists? && limit.present?
  end

  def limit
    @limit ||= klass.columns_hash["name"].limit
  end
end
